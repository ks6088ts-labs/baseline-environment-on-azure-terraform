variable "resource_group_name" {
  description = "Specifies the resource group name"
  type        = string
}

variable "name" {
  description = "Specifies the name of the Azure Container Registry"
  type        = string
}

variable "tags" {
  description = "Specifies the tags of the Azure Container Registry"
  type        = map(any)
  default     = {}
}

variable "location" {
  description = "Specifies the location of the Azure Container Registry"
  type        = string
}

variable "sku" {
  description = "Specifies the SKU of the Azure Container Registry"
  type        = string
  default     = "Standard"
}

variable "admin_enabled" {
  description = "Specifies whether the admin user is enabled"
  type        = bool
  default     = false
}
