# Create Azure AI Foundry resources

This is a scenario for creating Azure AI Foundry resources using AzAPI provider in Terraform.

## How to use

```shell
# Move to the scenario directory
cd infra/scenarios/create_ai_foundry

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

- [Microsoft.CognitiveServices accounts](https://learn.microsoft.com/en-us/azure/templates/microsoft.cognitiveservices/accounts?pivots=deployment-language-terraform#terraform-azapi-provider-resource-definition)
- [Microsoft.CognitiveServices accounts/projects](https://learn.microsoft.com/en-us/azure/templates/microsoft.cognitiveservices/accounts/projects?pivots=deployment-language-terraform)
