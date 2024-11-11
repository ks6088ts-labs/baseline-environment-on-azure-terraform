variable "create_github_repository" {
  description = "Specifies whether to create a GitHub repository"
  type        = bool
  default     = false
}

variable "organization" {
  description = "Specifies the GitHub organization"
  type        = string
  default     = "ks6088ts-labs"
}

variable "repository_name" {
  description = "Specifies the name of the GitHub repository"
  type        = string
  default     = "example-repository"
}

variable "repository_description" {
  description = "Specifies the description of the GitHub repository"
  type        = string
  default     = "This is an example repository created by Terraform"
}

variable "environment_name" {
  description = "Specifies the name of the GitHub repository environment"
  type        = string
  default     = "development"
}

variable "actions_environment_secrets" {
  description = "Specifies the environment secrets for the GitHub repository"
  type = list(object({
    name  = string
    value = string
  }))
  default = [
    {
      name  = "ARM_CLIENT_ID"
      value = "WU9VUl9DTElFTlRfSUQ="
    },
    {
      name  = "ARM_SUBSCRIPTION_ID"
      value = "WU9VUl9TVUJTQ1JJUFRJT05fSUQ="
    },
    {
      name  = "ARM_TENANT_ID"
      value = "WU9VUl9URU5BTlRfSUQ="
    },
    {
      name  = "ARM_USE_OIDC"
      value = "dHJ1ZQ==" # true or false
    },
  ]
}
