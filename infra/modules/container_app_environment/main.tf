terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.22.0"
    }
  }
}

resource "azurerm_container_app_environment" "container_app_environment" {
  name                = "${var.name}cae"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}
