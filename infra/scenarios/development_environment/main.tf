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

# Domain.Read.All
data "azuread_domains" "default" {
  only_initial = true
}

data "azurerm_subscription" "primary" {
}

data "azuread_client_config" "client_config" {
}

locals {
  domain_name = data.azuread_domains.default.domains[0].domain_name
}

# User.ReadWrite.All
resource "azuread_user" "user" {
  user_principal_name   = "${var.user_name}@${local.domain_name}"
  password              = "Password123!"
  force_password_change = true
  display_name          = var.user_name
  department            = "Engineering"
  job_title             = "Engineer"
}

# Group.ReadWrite.All
resource "azuread_group" "group" {
  display_name     = var.group_name
  security_enabled = true
}

resource "azuread_group_member" "group_members" {
  group_object_id  = azuread_group.group.object_id
  member_object_id = azuread_user.user.object_id
}

# https://learn.microsoft.com/en-us/azure/role-based-access-control/role-assignments-portal
resource "azurerm_role_assignment" "contributor" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Contributor"
  principal_id         = azuread_group.group.object_id
}

module "service_principal" {
  source = "../../modules/service_principal"

  name = var.service_principal_name
  owners = [
    data.azuread_client_config.client_config.object_id,
  ]
}

resource "azurerm_role_assignment" "contributor_sp" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Contributor"
  principal_id         = module.service_principal.service_principal_object_id
}
