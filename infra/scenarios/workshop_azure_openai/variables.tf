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
  default     = "nginx:latest"
}

variable "container_app_ingress_target_port" {
  description = "Specifies the target port of the ingress"
  type        = number
  default     = 80
}

variable "container_app_envs" {
  description = "Specifies the environment variables"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}
