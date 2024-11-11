terraform {
  required_version = ">= 1.6.0"
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "github" {
  owner = var.organization
}

locals {
  repository_name = var.create_github_repository ? github_repository.repository[0].name : var.repository_name
}

resource "github_repository" "repository" {
  # https://stackoverflow.com/a/60231673/4457856
  count = var.create_github_repository ? 1 : 0

  name        = var.repository_name
  description = var.repository_description
  visibility  = var.repository_visibility
}

resource "github_repository_environment" "repository_environment" {
  environment         = var.environment_name
  repository          = local.repository_name
  prevent_self_review = true
  deployment_branch_policy {
    protected_branches     = true
    custom_branch_policies = false
  }
}

resource "github_actions_environment_secret" "actions_environment_secret" {
  for_each = { for secret in var.actions_environment_secrets : secret.name => secret }

  repository      = local.repository_name
  environment     = github_repository_environment.repository_environment.environment
  secret_name     = each.value.name
  encrypted_value = each.value.value
}
