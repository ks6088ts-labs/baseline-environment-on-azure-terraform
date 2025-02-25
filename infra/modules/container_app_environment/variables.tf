variable "resource_group_name" {
  description = "Specifies the resource group name"
  type        = string
}

variable "location" {
  description = "Specifies the location of Azure Container Apps Environment"
  type        = string
}

variable "name" {
  description = "Specifies the name of the Azure Container Apps Environment"
  type        = string
}

variable "tags" {
  description = "Specifies the tags of the Azure Container Apps Environment"
  type        = map(any)
  default     = {}
}
