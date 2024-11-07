variable "name" {
  description = "(Required) Specifies the name of the application"
  type        = string
}

variable "owners" {
  description = "(Optional) Specifies the object IDs of the owners of the application"
  type        = list(string)
  default     = []
}
