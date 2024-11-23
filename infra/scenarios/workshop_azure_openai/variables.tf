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

variable "deployments" {
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
        version = "2024-05-13"
      }
      sku = {
        name     = "GlobalStandard"
        capacity = 450
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
  ]
}
