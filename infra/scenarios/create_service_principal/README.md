# Create a service principal

This is a scenario for creating a service principal in Microsoft Entra ID.

## Azure Active Directory Provider

### How to use

```shell
# Move to the scenario directory
cd infra/scenarios/create_service_principal

# Authenticate with Azure via Azure CLI
az login

# (Optional) Confirm the details for the currently logged-in user
az ad signed-in-user show

# Set environment variables
export ARM_SUBSCRIPTION_ID=$(az account show --query id --output tsv)
export TF_VAR_service_principal_name="baseline-environment-on-azure-terraform_tf"
export TF_VAR_github_environment="tf"

# Initialize the Terraform configuration.
terraform init

# Deploy the infrastructure
terraform apply -auto-approve

# Grant permissions to the application
application_object_id=$(terraform output -raw application_object_id)
az ad app permission admin-consent --id $application_object_id

# Destroy the infrastructure
terraform destroy -auto-approve
```

## Azure CLI

If you want to create a service principal using Azure CLI, you can refer to the [create-service-principal.sh](../../../scripts/create-service-principal.sh) script.

## References

### API Permissions

- [azuread_application](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application#api-permissions)
- [azuread_service_principal](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal#api-permissions)
