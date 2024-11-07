# Baseline Environment on Azure in Terraform

## Deploy infrastructure

[Azure Provider: Authenticating using the Azure CLI > Configuring Azure CLI authentication in Terraform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli#configuring-azure-cli-authentication-in-terraform)

```shell
# Log in to Azure
az login

# az ad signed-in-user show

# Set environment variables
export ARM_SUBSCRIPTION_ID=$(az account show --query id --output tsv)

# Set scenario name
SCENARIO="YOUR_SCENARIO"

# Deploy infrastructure
make deploy SCENARIO=${SCENARIO}
# or az group delete --name $RESOURCE_GROUP_NAME --yes
```

## Deploy backend storage for Terraform state

- [Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)
- [Backend Type: azurerm | Terraform](https://developer.hashicorp.com/terraform/language/backend/azurerm)
- [Override Files](https://developer.hashicorp.com/terraform/language/files/override)

```shell
# Set environment variables
export ARM_SUBSCRIPTION_ID=$(az account show --query id --output tsv)

# Set input variables
export TF_VAR_name="your-unique-name"

# Deploy infrastructure
cd infra
make deploy SCENARIO=tfstate_backend
```

## Override backend configuration

Currently, Terraform state is stored in the local file system. To store the state in Azure Storage, you can override the backend configuration by following the steps below:

```shell
# Go to the infra directory
cd infra

SCEANRIO="your_scenario_name"

# Create overrride.tf file
cat <<EOF > scenarios/$SCEANRIO/override.tf
terraform {
  backend "azurerm" {
    container_name       = "your-container-name"
    resource_group_name  = "your-resource-group-name"
    storage_account_name = "your-storage-account-name"
    key                  = "$SCEANRIO.tfstate"
  }
}
EOF

# Deploy infrastructure
export ARM_SUBSCRIPTION_ID=$(az account show --query id --output tsv)
make deploy SCENARIO=$SCEANRIO
```

## Run local tests

```shell
# Set environment variables
export ARM_CLIENT_ID=$appId
export ARM_CLIENT_SECRET=$password
export ARM_TENANT_ID=$tenant
export ARM_SUBSCRIPTION_ID=$SUBSCRIPTION_ID

# Run tests
cd infra
make ci-test
```

## Set up GitHub Actions

### Service Principal

[Azure Provider: Authenticating using a Service Principal with a Client Secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret)

```shell
SUBSCRIPTION_ID=$(az account show --query id --output tsv)

az ad sp create-for-rbac \
    --name="test-baseline-environment-on-azure-terraform" \
    --role="Contributor" \
    --scopes="/subscriptions/$SUBSCRIPTION_ID"
# {
#   "appId": "<YOUR_APPLICATION_ID>",
#   "displayName": "test-baseline-environment-on-azure-terraform",
#   "password": "<YOUR_PASSWORD>",
#   "tenant": "<YOUR_TENANT>"
# }

# Register secrets on GitHub
gh secret set ARM_CLIENT_ID --body $appId
gh secret set ARM_CLIENT_SECRET --body $password
gh secret set ARM_TENANT_ID --body $tenant
gh secret set ARM_SUBSCRIPTION_ID --body $SUBSCRIPTION_ID
```

### OpenID Connect

To configure the federated credential by following the steps below:

1. Install [GitHub CLI](https://cli.github.com/) and authenticate with GitHub.
1. [Create deployment environment](https://docs.github.com/en/actions/managing-workflow-runs-and-deployments/managing-deployments/managing-environments-for-deployment#creating-an-environment) on GitHub named `dev`.
1. Run a bash script to create a new service principal and configure OpenID Connect.

```shell
bash scripts/configure-oidc-github.sh
```

- [Authenticating using a Service Principal and OpenID Connect](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/service_principal_oidc)
- [Configuring OpenID Connect in Azure](https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-azure)
- [Check! GitHub Actions で OpenID Connect(OIDC) で Azure に安全に接続する](https://zenn.dev/dzeyelid/articles/5f20acbe549666)

# References

- [hashicorp/terraform-provider-azurerm](https://github.com/hashicorp/terraform-provider-azurerm)
