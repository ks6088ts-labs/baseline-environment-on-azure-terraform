variable "name" {
  description = "Specifies the name"
  type        = string
  default     = "createresourcegroup"
}

variable "location" {
  description = "Specifies the location"
  type        = string
  default     = "japaneast"
}

variable "tags" {
  description = "Specifies the tags"
  type        = map(any)
  default = {
    scenario = "create_resource_group"
  }
}
