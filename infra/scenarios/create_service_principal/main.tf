terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0.2"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.22.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_subscription" "primary" {
}

data "azuread_client_config" "client_config" {
}

data "azuread_application_published_app_ids" "well_known" {
}

data "azuread_service_principal" "msgraph" {
  client_id = data.azuread_application_published_app_ids.well_known.result["MicrosoftGraph"]
}

resource "azuread_application" "application" {
  display_name = var.service_principal_name
  owners = [
    data.azuread_client_config.client_config.object_id,
  ]
  required_resource_access {
    resource_app_id = data.azuread_application_published_app_ids.well_known.result["MicrosoftGraph"]
    dynamic "resource_access" {
      for_each = var.resource_access_permissions
      content {
        id   = data.azuread_service_principal.msgraph.app_role_ids[resource_access.value.resource_access_permission_name]
        type = resource_access.value.type
      }
    }
  }
}

resource "azuread_service_principal" "service_principal" {
  client_id                    = azuread_application.application.client_id
  app_role_assignment_required = false
  owners = [
    data.azuread_client_config.client_config.object_id,
  ]
}

resource "azurerm_role_assignment" "role_assignment_service_principal" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = var.role_definition_name
  principal_id         = azuread_service_principal.service_principal.object_id
}

resource "azuread_service_principal_password" "service_principal_password" {
  service_principal_id = azuread_service_principal.service_principal.id
}

resource "azuread_application_federated_identity_credential" "application_federated_identity_credential" {
  application_id = azuread_application.application.id
  display_name   = var.service_principal_name
  description    = "federated identity credential for ${var.service_principal_name}"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:${var.github_organization}/${var.github_repository}:environment:${var.github_environment}"
}
