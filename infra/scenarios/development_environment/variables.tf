variable "user_name" {
  description = "(Required) Specifies the user name"
  type        = string
  default     = "user"
}

variable "group_name" {
  description = "(Required) Specifies the group name"
  type        = string
  default     = "group"
}

variable "service_principal_name" {
  description = "(Required) Specifies the service principal name"
  type        = string
  default     = "development_environment"
}
