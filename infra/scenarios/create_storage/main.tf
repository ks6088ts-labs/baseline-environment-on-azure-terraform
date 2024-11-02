terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.name}-${random_string.resource_code.result}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "sa" {
  name                            = "${var.name}sa${random_string.resource_code.result}"
  location                        = azurerm_resource_group.rg.location
  tags                            = var.tags
  resource_group_name             = azurerm_resource_group.rg.name
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_2"

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_storage_container" "sc" {
  name                  = "${var.name}sc${random_string.resource_code.result}"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}
