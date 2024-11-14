terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.5.0"
    }
  }
}

resource "azurerm_storage_account" "storage_account" {
  name                            = "${var.name}sa"
  location                        = var.location
  tags                            = var.tags
  resource_group_name             = var.resource_group_name
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_storage_container" "storage_container" {
  name                  = "${var.name}sc"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}
