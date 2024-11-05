variable "resource_group_id" {
  description = "(Required) Specifies the resource group id"
  type        = string
}

variable "location" {
  description = "(Required) Specifies the location of the Bing Search"
  type        = string
}

variable "name" {
  description = "(Required) Specifies the name of the Bing Search"
  type        = string
}

variable "sku_name" {
  description = "(Optional) Specifies the sku name for the Bing Search"
  type        = string
}

variable "tags" {
  description = "(Optional) Specifies the tags of the Bing Search"
  type        = map(any)
  default     = {}
}
