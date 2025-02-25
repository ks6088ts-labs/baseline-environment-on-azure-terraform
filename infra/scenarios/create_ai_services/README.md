# Create AI resources in Azure

This is a scenario for creating AI resources in Azure using Terraform.

## How to use

```shell
# Move to the scenario directory
cd infra/scenarios/create_ai_services

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

## Deploy models

```shell
cp terraform.tfvars.example terraform.tfvars

terraform apply -auto-approve
```

## References

- [Azure OpenAI Service models](https://learn.microsoft.com/azure/ai-services/openai/concepts/models?tabs=global-standard%2Cstandard-chat-completions)
