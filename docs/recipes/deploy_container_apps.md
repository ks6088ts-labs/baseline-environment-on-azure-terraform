# Deploy container apps

## How to use

```shell
cd infra/scenarios/create_container_apps

# Set variables
export TF_VAR_image="ks6088ts/workshop-llm-agents:0.0.11"
export TF_VAR_ingress_target_port="8501"
export TF_VAR_envs='[
  {
    name  = "USE_MICROSOFT_ENTRA_ID"
    value = "False"
  },
  {
    name  = "AZURE_CLIENT_ID"
    value = "value"
  },
  {
    name  = "AZURE_CLIENT_SECRET"
    value = "value"
  },
  {
    name  = "AZURE_TENANT_ID"
    value = "value"
  },
  {
    name  = "AZURE_OPENAI_ENDPOINT"
    value = "FIXME"
  },
  {
    name  = "AZURE_OPENAI_API_KEY"
    value = "FIXME"
  },
  {
    name  = "AZURE_OPENAI_API_VERSION"
    value = "2024-10-21"
  },
  {
    name  = "AZURE_OPENAI_MODEL_EMBEDDING"
    value = "text-embedding-3-small"
  },
  {
    name  = "AZURE_OPENAI_MODEL_GPT"
    value = "gpt-4o"
  },
  {
    name  = "OLLAMA_MODEL_CHAT"
    value = "phi3"
  },
  {
    name  = "AZURE_COSMOS_DB_CONNECTION_STRING"
    value = "value"
  },
  {
    name  = "AZURE_COSMOS_DB_DATABASE_NAME"
    value = "value"
  },
  {
    name  = "AZURE_COSMOS_DB_CONTAINER_NAME"
    value = "value"
  },
  {
    name  = "AZURE_COSMOS_DB_ENDPOINT"
    value = "value"
  },
  {
    name  = "BING_SEARCH_URL"
    value = "https://api.bing.microsoft.com/v7.0/search"
  },
  {
    name  = "BING_SUBSCRIPTION_KEY"
    value = "FIXME"
  },
  {
    name  = "LANGSMITH_TRACING"
    value = "false"
  },
  {
    name  = "LANGSMITH_API_KEY"
    value = "value"
  },
]'

# set the subscription id
export ARM_SUBSCRIPTION_ID=$(az account show --query id --output tsv)

# deploy the infrastructure
terraform init
terraform apply -auto-approve
```

Check the deployment status:

```shell
# Retrieve the FQDN of the Azure Container Apps
export FQDN=$(terraform output -raw fqdn)

# Check the deployment status
curl -X GET "https://${FQDN}" -v
```
