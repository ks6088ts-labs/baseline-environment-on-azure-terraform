variable "resource_group_name" {
  description = "Specifies the resource group name"
  type        = string
}

variable "location" {
  description = "Specifies the location of the Azure OpenAI Service"
  type        = string
}

variable "name" {
  description = "Specifies the name of the Azure OpenAI Service"
  type        = string
}

variable "sku_name" {
  description = "Specifies the sku name for the Azure OpenAI Service"
  type        = string
  default     = "S0"
}

variable "tags" {
  description = "Specifies the tags of the Azure OpenAI Service"
  type        = map(any)
  default     = {}
}

variable "custom_subdomain_name" {
  description = "Specifies the custom subdomain name of the Azure OpenAI Service"
  type        = string
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
      name = string
    })
  }))
  default = []
}
