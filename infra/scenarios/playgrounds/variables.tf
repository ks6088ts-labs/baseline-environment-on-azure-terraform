variable "name" {
  description = "Specifies the name"
  type        = string
  default     = "playgrounds"
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
    scenario = "playgrounds"
  }
}

# ---
# Module: ai_services
# ---
variable "ai_services_deployments" {
  description = "List of configurations for the Azure AI Services deployments"
  type = list(object({
    location = string
    deployments = list(object({
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
  }))
  default = [
    {
      location    = "japaneast"
      deployments = []
    },
    {
      location    = "eastus"
      deployments = []
    },
    {
      location    = "eastus2"
      deployments = []
    },
  ]
}

# ---
# Module: aks
# ---
variable "aks_node_count" {
  description = "Specifies the number of nodes in the AKS cluster"
  type        = number
  default     = 1
}

# ---
# Module: container_app
# ---
variable "container_app_image" {
  description = "Specifies the container image"
  type        = string
  default     = "ks6088ts/gates-backend:latest"
}

variable "container_app_ingress_target_port" {
  description = "Specifies the target port of the ingress"
  type        = number
  default     = 8080
}

variable "container_app_envs" {
  description = "Specifies the environment variables"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}
