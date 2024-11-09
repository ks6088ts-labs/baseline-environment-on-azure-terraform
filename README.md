[![test](https://github.com/ks6088ts-labs/baseline-environment-on-azure-terraform/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/ks6088ts-labs/baseline-environment-on-azure-terraform/actions/workflows/test.yml?query=branch%3Amain)
[![deploy](https://github.com/ks6088ts-labs/baseline-environment-on-azure-terraform/actions/workflows/deploy.yml/badge.svg?branch=main)](https://github.com/ks6088ts-labs/baseline-environment-on-azure-terraform/actions/workflows/deploy.yml?query=branch%3Amain)

[![Open in GitHub Codespaces](https://img.shields.io/static/v1?style=for-the-badge&label=GitHub+Codespaces&message=Open&color=brightgreen&logo=github)](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=721866314&machine=basicLinux32gb&devcontainer_path=.devcontainer%2Fdevcontainer.json&location=SoutheastAsia)

# baseline-environment-on-azure-terraform

Baseline Environment on Azure in Terraform is a set of reference Terraform template

## Prerequisites

- [GNU Make](https://www.gnu.org/software/make/)
- [Terraform](https://github.com/Azure/azure-cli#installation) 1.6 or later

## Usage

See [Makefile](./infra/Makefile) for details.

```shell
# Show help
❯ cd infra; make help
```

## Scenarios

| Scenario                                                                       | Overview                                        |
| ------------------------------------------------------------------------------ | ----------------------------------------------- |
| [tfstate_backend](./infra/scenarios/tfstate_backend/README.md)                 | Create Terraform state backend on Azure Storage |
| [development_environment](./infra/scenarios/development_environment/README.md) | Development environment                         |
| [workshop_azure_openai](./infra/scenarios/workshop_azure_openai/README.md)     | Workshop Azure OpenAI                           |

## How to manage infrastructure on Azure using Terraform

[Azure Provider: Authenticating using the Azure CLI > Configuring Azure CLI authentication in Terraform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli#configuring-azure-cli-authentication-in-terraform)

```shell
# Go to the `infra` directory
cd infra

# Log in to Azure
az login

# (Optional) Confirm the details for the currently logged-in user
az ad signed-in-user show

# Set variables
export ARM_SUBSCRIPTION_ID=$(az account show --query id --output tsv)
SCENARIO="YOUR_SCENARIO"

# Deploy infrastructure
make deploy SCENARIO=$SCENARIO

# Destroy infrastructure
make destroy SCENARIO=$SCENARIO
```

## Customize deployment

### Override variables

- [Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)

```shell
# Go to the `infra` directory
cd infra

# Override `name` variable defined in `variables.tf`
export TF_VAR_name="youruniquename"

# Deploy infrastructure
make deploy SCENARIO=tfstate_backend
```

### Override backend configuration

Currently, Terraform state is stored in the local file system by default. To store the state in Azure Storage, you can override the backend configuration by creating an `override.tf` file.
Refer to the following documents for more information:

- [Backend Type: azurerm | Terraform](https://developer.hashicorp.com/terraform/language/backend/azurerm)
- [Override Files](https://developer.hashicorp.com/terraform/language/files/override)

Here is an example of how to override the backend configuration:

```shell
# Go to the infra directory
cd infra

# Create override.tf file to a specific scenario
SCENARIO="your_scenario_name" # e.g., "workshop_azure_openai"
cat <<EOF > scenarios/$SCENARIO/override.tf
terraform {
  backend "azurerm" {
    container_name       = "yourcontainername"
    resource_group_name  = "yourresourcegroupname"
    storage_account_name = "yourstorageaccountname"
    key                  = "$SCENARIO.tfstate"
  }
}
EOF
```

## Development

### Run local tests

```shell
# Set environment variables to authenticate using a service principal with a client secret
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

This is not recommended for production use, since the client secret needs to be stored in GitHub Actions secrets.
For production use, consider using OpenID Connect instead.

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
1. Run the following commands to create a new service principal and configure OpenID Connect.

```shell
# Create a new service principal
bash scripts/create-service-principal.sh

# Configure GitHub secrets
bash scripts/configure-github-secrets.sh

# add permissions to the service principal
APPLICATION_NAME="baseline-environment-on-azure-terraform"
appId=$(az ad sp list --display-name "$APPLICATION_NAME" --query "[0].appId" --output tsv)
MICROSOFT_GRAPH_API_ID="00000003-0000-0000-c000-000000000000"

# Add permissions to the service principal for Microsoft Graph API
# Domain.Read.All, Group.ReadWrite.All, GroupMember.ReadWrite.All, User.ReadWrite.All, Application.ReadWrite.All
permissions=(
  "dbb9058a-0e50-45d7-ae91-66909b5d4664"
  "62a82d76-70ea-41e2-9197-370581804d09"
  "dbaae8cf-10b5-4b86-a4a1-f871c94c6695"
  "741f803b-c850-494e-b5df-cde7c675a1ca"
  "1bfefb4e-e0b5-418b-a88f-73c46d2cc8e9"
)

for permission in "${permissions[@]}"; do
  az ad app permission add \
    --id $appId \
    --api $MICROSOFT_GRAPH_API_ID \
    --api-permissions $permission=Role
done

# grant admin consent
az ad app permission admin-consent --id $appId
```

- [Authenticating using a Service Principal and OpenID Connect](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/service_principal_oidc)
- [Configuring OpenID Connect in Azure](https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-azure)
- [Check! GitHub Actions で OpenID Connect(OIDC) で Azure に安全に接続する](https://zenn.dev/dzeyelid/articles/5f20acbe549666)

# References

- [hashicorp/terraform-provider-azurerm](https://github.com/hashicorp/terraform-provider-azurerm)
- [Use GitHub Actions to connect to Azure](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-github-actions?tabs=CLI%2Cuserlevel#configure-the-github-secrets)
- [Microsoft Graph permissions reference](https://learn.microsoft.com/en-us/graph/permissions-reference)
