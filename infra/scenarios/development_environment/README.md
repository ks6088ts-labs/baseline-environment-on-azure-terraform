# Development Environment

This is a scenario for describing how to create resources for development environment.

## Set up development environment

```shell
# Go to the infra directory
cd infra

# Set scenario name
SCENARIO="development_environment"

# Create override.tf file to store Terraform state in Azure Storage
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

# Log in to Azure
az login

# (Optional) Confirm the details for the currently logged-in user
az ad signed-in-user show

# Set environment variables
export ARM_SUBSCRIPTION_ID=$(az account show --query id --output tsv)

# Deploy infrastructure
make deploy SCENARIO=$SCENARIO

# Get output variables
cd scenarios/$SCENARIO
application_object_id=$(terraform output -raw application_object_id)

az ad app permission admin-consent --id $application_object_id
```

## [Configuring the Service Principal in Terraform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret#configuring-the-service-principal-in-terraform)

```shell
cd scenarios/$SCENARIO

# To authenticate using a Service Principal with a Client Secret, pass the following environment variables:
export ARM_TENANT_ID=$(terraform output -raw tenant_id)
export ARM_SUBSCRIPTION_ID=$(az account show --query id --output tsv)
export ARM_CLIENT_ID=$(terraform output -raw service_principal_client_id)
export ARM_CLIENT_SECRET=$(terraform output -raw service_principal_password)

# Hooray 🎉, you can now run Terraform commands which will use the Service Principal to authenticate
# For example, you can run the following command to run CI tests using the Service Principal
make ci-test
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
