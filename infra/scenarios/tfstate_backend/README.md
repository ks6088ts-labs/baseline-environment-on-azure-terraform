# Create Terraform state backend on Azure Storage

This is a scenario for creating a Terraform state backend in Azure Storage.

## How to use

```shell
# Move to the scenario directory
cd infra/scenarios/tfstate_backend

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

## References

- [Store Terraform state in Azure Storage](https://learn.microsoft.com/azure/developer/terraform/store-state-in-azure-storage?tabs=terraform)
