variable "resource_group_name" {
  description = "(Required) Specifies the resource group name"
  type        = string
}

variable "location" {
  description = "(Required) Specifies the location of the Azure OpenAI Service"
  type        = string
}

variable "name" {
  description = "(Required) Specifies the name of the Azure OpenAI Service"
  type        = string
}

variable "sku_name" {
  description = "(Optional) Specifies the sku name for the Azure OpenAI Service"
  type        = string
  default     = "S0"
}

variable "tags" {
  description = "(Optional) Specifies the tags of the Azure OpenAI Service"
  type        = map(any)
  default     = {}
}

variable "custom_subdomain_name" {
  description = "(Optional) Specifies the custom subdomain name of the Azure OpenAI Service"
  type        = string
}

variable "deployments" {
  description = "(Optional) Specifies the deployments of the Azure OpenAI Service"
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
