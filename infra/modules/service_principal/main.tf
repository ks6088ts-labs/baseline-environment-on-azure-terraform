terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0.2"
    }
  }
}

# Application.ReadWrite.All
resource "azuread_application" "application" {
  display_name = var.name
  owners       = var.owners
}

resource "azuread_service_principal" "service_principal" {
  client_id                    = azuread_application.application.client_id
  app_role_assignment_required = false
  owners                       = var.owners
}
