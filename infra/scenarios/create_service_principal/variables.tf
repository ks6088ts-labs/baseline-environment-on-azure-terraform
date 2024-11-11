variable "service_principal_name" {
  description = "Specifies the service principal name"
  type        = string
  default     = "baseline-environment-on-azure-terraform_ci"
}

variable "role_definition_name" {
  description = "Specifies the role definition name"
  type        = string
  default     = "Contributor"
}
