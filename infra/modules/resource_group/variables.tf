variable "name" {
  description = "(Required) Specifies the resource group name"
  type        = string
}

variable "location" {
  description = "(Required) Specifies the location for the resource group"
  type        = string
}

variable "tags" {
  description = "(Optional) Specifies the tags of the resource group"
  type        = map(any)
  default     = {}
}
