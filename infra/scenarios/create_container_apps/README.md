# Create Azure Container Apps

This is a scenario for creating Azure Container Apps.

## How to use

```shell
# Move to the scenario directory
cd infra/scenarios/create_container_apps

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

- [Azure Policy built-in policy definitions](https://learn.microsoft.com/ja-jp/azure/governance/policy/samples/built-in-policies)
- [Azure Policy Samples](https://github.com/Azure/azure-policy)
- [azurerm_subscription_policy_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subscription_policy_assignment)
