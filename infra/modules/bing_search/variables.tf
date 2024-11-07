variable "resource_group_id" {
  description = "Specifies the resource group id"
  type        = string
}

variable "location" {
  description = "Specifies the location of the Bing Search"
  type        = string
}

variable "name" {
  description = "Specifies the name of the Bing Search"
  type        = string
}

variable "sku_name" {
  description = "Specifies the sku name for the Bing Search"
  type        = string
}

variable "tags" {
  description = "Specifies the tags of the Bing Search"
  type        = map(any)
  default     = {}
}
