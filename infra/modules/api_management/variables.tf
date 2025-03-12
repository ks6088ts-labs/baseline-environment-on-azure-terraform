variable "resource_group_name" {
  description = "Specifies the resource group name"
  type        = string
}

variable "name" {
  description = "Specifies the name of the Azure API Management"
  type        = string
}

variable "tags" {
  description = "Specifies the tags of the Azure API Management"
  type        = map(any)
  default     = {}
}

variable "location" {
  description = "Specifies the location of the Azure API Management"
  type        = string
}

variable "sku_name" {
  description = "Specifies the SKU of the Azure API Management"
  type        = string
  default     = "Consumption_0"
}

variable "publisher_email" {
  description = "Specifies the publisher email of the Azure API Management"
  type        = string
  default     = "example@example.com"
}

variable "publisher_name" {
  description = "Specifies the publisher name of the Azure API Management"
  type        = string
  default     = "Example Publisher"
}
