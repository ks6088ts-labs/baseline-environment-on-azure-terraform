# ---
# Common variables
# ---
variable "name" {
  description = "Specifies the name"
  type        = string
  default     = "workshopazureopenai"
}

variable "location" {
  description = "Specifies the location"
  type        = string
  default     = "japaneast"
}

variable "tags" {
  description = "Specifies the tags"
  type        = map(any)
  default = {
    scenario = "workshop_azure_openai"
  }
}

# ---
# Feature flags
# ---
variable "create_bing_search" {
  description = "Specifies whether to create a Bing Search resource"
  type        = bool
  default     = false
}

variable "create_container_app" {
  description = "Specifies whether to create a container app"
  type        = bool
  default     = false
}

variable "create_cosmosdb" {
  description = "Specifies whether to create a CosmosDB account"
  type        = bool
  default     = false
}

variable "create_aks" {
  description = "Specifies whether to create an Azure Kubernetes Service"
  type        = bool
  default     = false
}

# ---
# Module: ai_services
# ---
variable "ai_services_deployments" {
  description = "Specifies the deployments of the Azure OpenAI Service"
  type = list(object({
    name = string
    model = object({
      name    = string
      version = string
    })
    sku = object({
      name     = string
      capacity = number
    })
  }))
  default = [
    {
      name = "gpt-4o"
      model = {
        name    = "gpt-4o"
        version = "2024-08-06"
      }
      sku = {
        name     = "GlobalStandard"
        capacity = 450
      },
    },
    {
      name = "gpt-4o-mini"
      model = {
        name    = "gpt-4o-mini"
        version = "2024-07-18"
      }
      sku = {
        name     = "GlobalStandard"
        capacity = 2000
      },
    },
    {
      name = "text-embedding-3-small"
      model = {
        name    = "text-embedding-3-small"
        version = "1"
      }
      sku = {
        name     = "Standard"
        capacity = 350
      },
    },
    {
      name = "text-embedding-3-large"
      model = {
        name    = "text-embedding-3-large"
        version = "1"
      }
      sku = {
        name     = "Standard"
        capacity = 350
      },
    },
  ]
}

# ---
# Module: container_app
# ---
variable "container_app_image" {
  description = "Specifies the container image"
  type        = string
  default     = "ks6088ts/workshop-llm-agents:0.0.11"
}

variable "container_app_ingress_target_port" {
  description = "Specifies the target port of the ingress"
  type        = number
  default     = 8501
}

variable "container_app_envs" {
  description = "Specifies the environment variables"
  type = list(object({
    name  = string
    value = string
  }))
  default = [
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
  ]
}
