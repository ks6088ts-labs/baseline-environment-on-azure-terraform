# Deploy container apps

## How to use

```shell
cd infra/scenarios/workshop_azure_openai

# Authenticate with Azure via Azure CLI
az login

# (Optional) Confirm the details for the currently logged-in user
az ad signed-in-user show

# set the subscription id
export ARM_SUBSCRIPTION_ID=$(az account show --query id --output tsv)

# Deploy Azure OpenAI Service
terraform init
terraform apply -auto-approve

# Retrieve the Azure OpenAI Service endpoint and API key
AZURE_OPENAI_ENDPOINT=$(terraform output -raw ai_services_endpoint)
AZURE_OPENAI_API_KEY=$(terraform output -raw ai_services_primary_access_key)

# Create the tfvars file
cat <<EOF > terraform.tfvars
create_container_app = "true"
container_app_image = "ks6088ts/workshop-llm-agents:0.0.11"
container_app_ingress_target_port = "8501"
container_app_envs = [
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
    value = "$AZURE_OPENAI_ENDPOINT"
  },
  {
    name  = "AZURE_OPENAI_API_KEY"
    value = "$AZURE_OPENAI_API_KEY"
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
]
EOF

# deploy the infrastructure
terraform init
terraform apply -auto-approve
```
