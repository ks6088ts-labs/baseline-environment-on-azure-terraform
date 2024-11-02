variable "name" {
  description = "(Required) Specifies the name"
  type        = string
  default     = "createstorage"
}

variable "location" {
  description = "(Required) Specifies the location"
  type        = string
  default     = "japaneast"
}

variable "tags" {
  description = "(Optional) Specifies the tags"
  type        = map(any)
  default = {
    scenario = "create_storage"
  }
}
