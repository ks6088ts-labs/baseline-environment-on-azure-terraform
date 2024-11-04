terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0.2"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.5.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azuread_domains" "default" {
  only_initial = true
}

data "azurerm_subscription" "primary" {
}

locals {
  domain_name = data.azuread_domains.default.domains[0].domain_name
}

resource "azuread_user" "user" {
  user_principal_name   = "${var.user_name}@${local.domain_name}"
  password              = "Password123!"
  force_password_change = true
  display_name          = var.user_name
  department            = "Engineering"
  job_title             = "Engineer"
}

resource "azuread_group" "group" {
  display_name     = var.group_name
  security_enabled = true
}

resource "azuread_group_member" "group_members" {
  group_object_id  = azuread_group.group.object_id
  member_object_id = azuread_user.user.object_id
}

resource "azurerm_role_assignment" "contributor" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Contributor"
  principal_id         = azuread_group.group.object_id
}
