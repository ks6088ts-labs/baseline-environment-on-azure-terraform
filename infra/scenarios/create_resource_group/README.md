# Create resource group

This is a scenario for creating an Azure resource group using Terraform.

## How to use

```shell
# Move to the scenario directory
cd infra/scenarios/create_resource_group

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

### To use Azure Storage for state management

Create a file named `backend.tf` with the following content. See [Example Backend Configurations](https://developer.hashicorp.com/terraform/language/backend/azurerm#example-backend-configurations) for more details.

```shell
# Copy the example backend configuration
cp backend.tf.example backend.tf

# Initialize the Terraform configuration.
terraform init

# Optionally, you can specify the backend configuration in the command line
terraform init \
  -backend-config="resource_group_name=rg-tfstatebackend-746a1" \
  -backend-config="storage_account_name=satfstatebackend746a1sa" \
  -backend-config="container_name=satfstatebackend746a1sc" \
  -backend-config="key=createresourcegroup.terraform.tfstate"
```

## References

- [Store Terraform state in Azure Storage](https://learn.microsoft.com/azure/developer/terraform/store-state-in-azure-storage?tabs=terraform)
