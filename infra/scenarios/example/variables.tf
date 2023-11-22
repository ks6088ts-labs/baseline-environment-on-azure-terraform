variable "name_prefix" {
  description = "(Optional) A prefix for the name of all the resource groups and resources."
  default     = null
  type        = string
  nullable    = true
}

variable "location" {
  description = "Specifies the location for the resource group and all the resources"
  default     = "japaneast"
  type        = string
}

variable "tags" {
  description = "(Optional) Specifies tags for all the resources"
  default = {
    scenario = "example"
  }
}

variable "resource_group_name" {
  description = "Specifies the resource group name"
  default     = "rg"
  type        = string
}
