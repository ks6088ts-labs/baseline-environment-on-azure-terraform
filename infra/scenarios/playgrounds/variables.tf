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
