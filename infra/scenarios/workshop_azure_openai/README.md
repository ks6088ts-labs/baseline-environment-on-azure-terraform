# Workshop for Azure OpenAI Service

This is a scenario for describing how to create resources for [Workshop for Azure OpenAI Service](https://ks6088ts-labs.github.io/workshop-azure-openai/)

## How to use

```shell
# (Optional) Use task runner
# cd infra; make deploy SCENARIO=workshop_azure_openai

# Move to the scenario directory
cd infra/scenarios/workshop_azure_openai

# Log in to Azure
az login

# (Optional) Confirm the details for the currently logged-in user
az ad signed-in-user show

# Set environment variables
export ARM_SUBSCRIPTION_ID=$(az account show --query id --output tsv)

# Set the feature flag to create resources
# export TF_VAR_create_container_app="true"

# Initialize the Terraform configuration.
terraform init

# Deploy the infrastructure
terraform apply -auto-approve

# Destroy the infrastructure
terraform destroy -auto-approve
```

## Supported use cases

- [Deploy container apps](../../../docs/recipes/deploy_container_apps.md)

## References

- [Azure/terraform-azurerm-avm-res-cognitiveservices-account](https://github.com/Azure/terraform-azurerm-avm-res-cognitiveservices-account)
- [ks6088ts-labs/workshop-azure-openai](https://github.com/ks6088ts-labs/workshop-azure-openai)
- [Cognitive services broken by Azure API change #9102](https://github.com/hashicorp/terraform-provider-azurerm/issues/9102)
