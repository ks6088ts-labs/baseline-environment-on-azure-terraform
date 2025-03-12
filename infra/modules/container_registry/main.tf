terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.22.0"
    }
  }
}

resource "azurerm_container_registry" "container_registry" {
  name                = "${var.name}acr"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
  sku                 = var.sku
  admin_enabled       = var.admin_enabled
  identity {
    type = "SystemAssigned"
  }
}
