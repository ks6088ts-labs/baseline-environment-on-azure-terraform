# Create Container App

Azure Portal 経由でデプロイした既存リソースを、Terraform 管理下に移行する手順を説明します。
ここでは、Container App に MCP サーバーをデプロイするシナリオを例に説明します。

## 前提条件

- Azure サブスクリプションを持っていること

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

**動作確認:**

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
