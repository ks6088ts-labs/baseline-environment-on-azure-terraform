# Create a service principal

This is a scenario for creating a service principal in Microsoft Entra ID.

## Deploy resources

```shell
# Go to the infra directory
cd infra

# Set scenario name
SCENARIO="create_service_principal"

# Log in to Azure
az login

# (Optional) Confirm the details for the currently logged-in user
az ad signed-in-user show

# Set environment variables
export ARM_SUBSCRIPTION_ID=$(az account show --query id --output tsv)
export TF_VAR_service_principal_name="baseline-environment-on-azure-terraform_tf"
export TF_VAR_github_environment="tf"

# Deploy infrastructure
make deploy SCENARIO=$SCENARIO

# Get output variables
cd scenarios/$SCENARIO
application_object_id=$(terraform output -raw application_object_id)

# Grant permissions to the application
az ad app permission admin-consent --id $application_object_id
```

## API Permissions

- [azuread_application](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application#api-permissions)
- [azuread_service_principal](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal#api-permissions)
