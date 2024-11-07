variable "name" {
  description = "Specifies the resource group name"
  type        = string
}

variable "location" {
  description = "Specifies the location for the resource group"
  type        = string
}

variable "tags" {
  description = "Specifies the tags of the resource group"
  type        = map(any)
  default     = {}
}

variable "resource_group_name" {
  description = "Specifies the resource group name"
  type        = string
}
