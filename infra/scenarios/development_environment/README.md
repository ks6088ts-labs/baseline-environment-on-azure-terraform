# Development Environment

This is a scenario for describing how to create resources for development environment.

## [Configuring the Service Principal in Terraform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret#configuring-the-service-principal-in-terraform)

```shell
# Set the following environment variables
export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
export ARM_CLIENT_SECRET="12345678-0000-0000-0000-000000000000"
export ARM_TENANT_ID="10000000-0000-0000-0000-000000000000"
export ARM_SUBSCRIPTION_ID=$(az account show --query id --output tsv)
```

## API Permissions

- [azuread_domains](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/domains#api-permissions)
- [azuread_user](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/user#api-permissions)
- [azuread_group](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#api-permissions)
- [azuread_group_member](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group_member#api-permissions)
- [azuread_application](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application#api-permissions)
- [azuread_service_principal](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal#api-permissions)

## References

- [Enable per-user Microsoft Entra multifactor authentication to secure sign-in events](https://learn.microsoft.com/entra/identity/authentication/howto-mfa-userstates)
- [Assign Azure roles using the Azure portal](https://learn.microsoft.com/azure/role-based-access-control/role-assignments-portal)
- [Quickstart: Deploy Bicep files by using GitHub Actions > Generate deployment credentials](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-github-actions?tabs=CLI%2Cuserlevel#generate-deployment-credentials)
- [Quickstart: Deploy Bicep files by using GitHub Actions > Configure the GitHub secrets](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-github-actions?tabs=CLI%2Cuserlevel#configure-the-github-secrets)
