# Create Container App

Azure Portal 経由でデプロイした既存リソースを、Terraform 管理下に移行する手順を説明します。
ここでは、Container App に MCP サーバーをデプロイするシナリオを例に説明します。

## 前提条件

- Azure サブスクリプションを持っていること
- Azure CLI がインストールされていること
- Terraform >= 1.5 (import block 利用のため)がインストールされていること

## 手順

### 1. Azure Portal を使用して Container App を作成する

1. Azure Portal の検索バーで「Container Apps」を検索し、Container Apps の管理画面に移動します。
1. `Create > Container App` をクリックして、新しい Container App の作成を開始します。
1. Resource Group は必要に応じて新規作成するか、既存のものを選択します。
1. Container App Environment は必要に応じて新規作成するか、既存のものを選択します。
1. Container Image の設定で、`Docker Hub` から `ks6088ts/template-mcp-python:0.0.4` を指定します。
1. Command: `python`, Arguments: `scripts/mcp_runner.py, image-transfer, --transport, streamable-http` に override します。
1. 環境変数として、`MCP_HOST=0.0.0.0`, `MCP_PORT=8000` を設定します。
1. イングレスを有効にして、外部からアクセスできるようにします。ターゲットポートは `8000` に設定します。
1. Create をクリックして、Container App の作成を完了します。

**参考:**

- [クイックスタート: Azure portal を使用して最初のコンテナー アプリをデプロイする](https://learn.microsoft.com/ja-jp/azure/container-apps/quickstart-portal)
- [Azure Container Apps でのイングレス](https://learn.microsoft.com/ja-jp/azure/container-apps/ingress-overview)

**動作確認(任意):**

デプロイした MCP サーバーに対して、クライアントから疎通確認を行います。

```shell
URL=http://<your-container-app-url>/mcp

curl -s $URL | jq -r .
{
  "jsonrpc": "2.0",
  "id": "server-error",
  "error": {
    "code": -32600,
    "message": "Not Acceptable: Client must accept text/event-stream"
  }
}
```

### 2. Terraform import block を使用して既存リソースを取り込む

以下の記事を参考に、Terraform の import block を活用して既存リソースを Terraform 定義ファイルに取り込みます。

- [Import resources overview](https://developer.hashicorp.com/terraform/language/import)
- [import ブロックを使用して既存 Azure リソースを Terraform 定義ファイルに取り込む](https://blog.jbs.co.jp/entry/2024/03/11/160601)

```shell
RESOURCE_GROUP_NAME=YOUR_RESOURCE_GROUP_NAME
CONTAINER_APP_ENVIRONMENT_NAME=YOUR_CONTAINER_APP_ENVIRONMENT_NAME
CONTAINER_APP_NAME=YOUR_CONTAINER_APP_NAME

cd infra/scenarios/create_container_app

touch variables.tf outputs.tf

cat << EOF > main.tf
terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0.2"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.22.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
import {
  id = "/subscriptions/<サブスクリプションID>/resourceGroups/${RESOURCE_GROUP_NAME}"
  to = azurerm_resource_group.rg
}

# Container App Environment
import {
  id = "/subscriptions/<サブスクリプションID>/resourceGroups/${RESOURCE_GROUP_NAME}/providers/Microsoft.App/managedEnvironments/${CONTAINER_APP_ENVIRONMENT_NAME}"
  to = azurerm_container_app_environment.env
}

# Container App
import {
    id = "/subscriptions/<サブスクリプションID>/resourceGroups/${RESOURCE_GROUP_NAME}/providers/Microsoft.App/containerApps/${CONTAINER_APP_NAME}"
    to = azurerm_container_app.app
}
EOF
```

対象のリソースグループとその配下のリソースの詳細を JSON 形式でエクスポートします。

```shell
az resource list \
 --resource-group $RESOURCE_GROUP_NAME \
 --output json > exported_resources.json
```

リソース群の情報に合わせて、`main.tf` の import block の ID やパラメータ部分を生成 AI を使って書き換えます。
import block の id フィールドが、デプロイ済みリソースの正しい ID で書き換えられていることを確認してください。

```prompt
#file:exported_resources.json のリソース群の情報に合わせて、 #file:main.tf の import block の ID やパラメータ部分を書き換えてください。
```

import block の内容が正しいことを確認したら、Terraform の初期化と import block に基づいてリソース定義のコードを生成します。ここでは `imported.tf` というファイル名で出力します。

```shell
terraform init

export ARM_SUBSCRIPTION_ID=$(az account show --query id --output tsv)

terraform plan -generate-config-out="imported.tf"
```

`imported.tf` の内容を `terraform plan` を実行して確認します。
import されたコードは、現在のリソース情報に合わせてハードコードされた形式で出力されるため、他のシナリオでも再利用する場合はリファクタリングが必要です。

不要なパラメータや、デフォルト値と同じ値が設定されている箇所があれば削除したり、変数化できる部分は変数化、モジュール化して共通化を図ります。`terraform plan` を再度実行し、エラーが発生しないことを確認します。

ここではプロンプトで必要最小限のことをスコープとして指定し、生成 AI による `imported.tf` のリファクタリング案を提示してもらいます。

```prompt
#file:imported.tf を以下の観点に従ってリファクタしてください。

- 明示的に指定する必要のない Optional な変数指定は削除
- 必須パラメータでハードコードされた変数は #file:variables.tf に定義して変数化し、尤もらしいデフォルト値を設定
- #file:outputs.tf に出力変数として外部からアクセスできると利便性のあるもののみを限定して定義
```

他にも [Terraform MCP Server](https://github.com/hashicorp/terraform-mcp-server) を利用したり、`terraform plan` などの validation コマンドに成功するまでを繰り返し AI にリファクタリングを依頼することも考えられます。
実装が完了したら、`main.tf` と `imported.tf` をマージし、`imported.tf` を削除します。

## How to use

```shell
# Move to the scenario directory
cd infra/scenarios/create_container_app

# Log in to Azure
az login

# (Optional) Confirm the details for the currently logged-in user
az ad signed-in-user show

# Set environment variables
export ARM_SUBSCRIPTION_ID=$(az account show --query id --output tsv)

# Initialize the Terraform configuration.
terraform init

# Deploy the infrastructure
terraform apply -auto-approve

# Destroy the infrastructure
terraform destroy -auto-approve
```
