terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.81.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {
}

resource "random_string" "prefix" {
  length  = 6
  special = false
  upper   = false
  numeric = false
}

module "resource_group" {
  source   = "../../modules/resource_group"
  name     = var.name_prefix == null ? "${random_string.prefix.result}-${var.resource_group_name}" : "${var.name_prefix}-${var.resource_group_name}"
  location = var.location
  tags     = var.tags
}
