# Baseline Environment on Azure in Terraform

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

Configure the federated credential by following the steps below:

- [Authenticating using a Service Principal and OpenID Connect](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/service_principal_oidc)
- [Configuring OpenID Connect in Azure](https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-azure)
- [Check! GitHub Actions で OpenID Connect(OIDC) で Azure に安全に接続する](https://zenn.dev/dzeyelid/articles/5f20acbe549666)

```shell
gh secret set ARM_CLIENT_ID --body $appId --env dev
gh secret set ARM_SUBSCRIPTION_ID --body $SUBSCRIPTION_ID --env dev
gh secret set ARM_TENANT_ID --body $tenant --env dev
gh secret set ARM_USE_OIDC --body "true" --env dev
```

## Deploy infrastructure

[Azure Provider: Authenticating using the Azure CLI > Configuring Azure CLI authentication in Terraform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli#configuring-azure-cli-authentication-in-terraform)

```shell
# Set environment variables
export ARM_SUBSCRIPTION_ID=$(az account show --query id --output tsv)

# Deploy infrastructure
make deploy SCENARIO=example
```

## Destroy infrastructure

```shell
# Set environment variables
export ARM_SUBSCRIPTION_ID=$(az account show --query id --output tsv)

make destroy SCENARIO=example
# or az group delete --name $RESOURCE_GROUP_NAME --yes
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

# References

- [hashicorp/terraform-provider-azurerm](https://github.com/hashicorp/terraform-provider-azurerm)
