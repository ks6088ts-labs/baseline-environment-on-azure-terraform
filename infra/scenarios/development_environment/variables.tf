variable "user_name" {
  description = "Specifies the user name"
  type        = string
  default     = "user"
}

variable "group_name" {
  description = "Specifies the group name"
  type        = string
  default     = "group"
}

variable "service_principal_name" {
  description = "Specifies the service principal name"
  type        = string
  default     = "development_environment"
}

variable "role_definition_name" {
  description = "Specifies the role definition name"
  type        = string
  default     = "Contributor"
}
