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

variable "github_organization" {
  description = "Specifies the GitHub organization"
  type        = string
  default     = "ks6088ts-labs"
}

variable "github_repository" {
  description = "Specifies the GitHub repository"
  type        = string
  default     = "baseline-environment-on-azure-terraform"
}

variable "github_environment" {
  description = "Specifies the GitHub environment"
  type        = string
  default     = "ci"
}
