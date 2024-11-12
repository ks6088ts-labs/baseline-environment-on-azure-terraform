[![test](https://github.com/ks6088ts-labs/baseline-environment-on-azure-terraform/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/ks6088ts-labs/baseline-environment-on-azure-terraform/actions/workflows/test.yml?query=branch%3Amain)
[![deploy](https://github.com/ks6088ts-labs/baseline-environment-on-azure-terraform/actions/workflows/deploy.yml/badge.svg?branch=main)](https://github.com/ks6088ts-labs/baseline-environment-on-azure-terraform/actions/workflows/deploy.yml?query=branch%3Amain)

[![Open in GitHub Codespaces](https://img.shields.io/static/v1?style=for-the-badge&label=GitHub+Codespaces&message=Open&color=brightgreen&logo=github)](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=721866314&machine=basicLinux32gb&devcontainer_path=.devcontainer%2Fdevcontainer.json&location=SoutheastAsia)

# baseline-environment-on-azure-terraform

Baseline Environment on Azure in Terraform is a set of reference Terraform template

## Prerequisites

- [GNU Make](https://www.gnu.org/software/make/)
- [Terraform](https://github.com/Azure/azure-cli#installation) 1.6 or later
- [Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli)
- [GitHub CLI](https://cli.github.com/)

For development:

- [tflint](https://github.com/terraform-linters/tflint)
- [tfsec](https://github.com/aquasecurity/tfsec)

## Usage

See [Makefile](./infra/Makefile) for details.

```shell
# Show help
❯ cd infra; make help
ci-test                        ci test
deploy                         deploy resources
destroy                        destroy resources
format                         format terraform codes
info                           show information
install-deps-dev               install dependencies for development
test                           test codes
```

## Scenarios

| Scenario                                                                         | Overview                                                                                                         |
| -------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| [configure_github_secrets](./infra/scenarios/configure_github_secrets/README.md) | Configure GitHub secrets ( CLI version: [configure-github-secrets.sh](./scripts/configure-github-secrets.sh) )   |
| [create_service_principal](./infra/scenarios/create_service_principal/README.md) | Create a service principal ( CLI version: [create-service-principal.sh](./scripts/create-service-principal.sh) ) |
| [create_user_group](./infra/scenarios/create_user_group/README.md)               | Create a new user and group in Microsoft Entra ID                                                                |
| [tfstate_backend](./infra/scenarios/tfstate_backend/README.md)                   | Create Terraform state backend on Azure Storage                                                                  |
| [workshop_azure_openai](./infra/scenarios/workshop_azure_openai/README.md)       | Workshop for Azure OpenAI Service                                                                                |

## How to manage infrastructure on Azure using Terraform

[Azure Provider: Authenticating using the Azure CLI > Configuring Azure CLI authentication in Terraform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli#configuring-azure-cli-authentication-in-terraform)

```shell
# Go to the `infra` directory
cd infra

# Log in to Azure
az login

# (Optional) Confirm the details for the currently logged-in user
az ad signed-in-user show

# Authenticate with a GitHub host.
gh auth login

# (Optional) Display active account and authentication state on each known GitHub host.
gh auth status

# Set variables
export ARM_SUBSCRIPTION_ID=$(az account show --query id --output tsv)
SCENARIO="YOUR_SCENARIO"

# Deploy infrastructure
make deploy SCENARIO=$SCENARIO

# Destroy infrastructure
make destroy SCENARIO=$SCENARIO
```

## Customize deployment

### Override [Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)

```shell
# Override `name` variable defined in `variables.tf`
export TF_VAR_name="youruniquename"

# Deploy infrastructure
terraform apply
```

### [Override Files](https://developer.hashicorp.com/terraform/language/files/override)

Currently, Terraform state is stored in the local file system by default. To store the state in Azure Storage, you can override the backend configuration by creating an `override.tf` file.
Refer to the following documents for more information:

- [Backend Type: azurerm | Terraform](https://developer.hashicorp.com/terraform/language/backend/azurerm)

Here is an example of how to override the backend configuration:

```shell
SCENARIO="your_scenario_name" # e.g., "workshop_azure_openai"

# Go to the infra directory
cd infra/scenarios/$SCENARIO

# Create override.tf file to a specific scenario
cat <<EOF > override.tf
terraform {
  backend "azurerm" {
    container_name       = "yourcontainername"
    resource_group_name  = "yourresourcegroupname"
    storage_account_name = "yourstorageaccountname"
    key                  = "$SCENARIO.tfstate"
  }
}
EOF

# Do something like `terraform init`, `terraform apply`, etc.
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

[Azure Provider: Authenticating using a Service Principal with a Client Secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret) describes several ways about how to authenticate with Azure.

### Service Principal

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

### (Recommended) OpenID Connect

To configure the federated credential by following the steps below:

1. Install [GitHub CLI](https://cli.github.com/) and authenticate with GitHub.
1. Run the following commands to create a new service principal and configure OpenID Connect.

```shell
# Create a new service principal
bash scripts/create-service-principal.sh

# Configure GitHub secrets
bash scripts/configure-github-secrets.sh
```

- [Authenticating using a Service Principal and OpenID Connect](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/service_principal_oidc)
- [Configuring OpenID Connect in Azure](https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-azure)

# References

- [hashicorp/terraform-provider-azurerm](https://github.com/hashicorp/terraform-provider-azurerm)
- [Use GitHub Actions to connect to Azure](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-github-actions?tabs=CLI%2Cuserlevel#configure-the-github-secrets)
- [Microsoft Graph permissions reference](https://learn.microsoft.com/en-us/graph/permissions-reference)
