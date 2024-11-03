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
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.5.0"
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

module "ai_services" {
  source                = "../../modules/ai_services"
  name                  = "${var.name}aiservices${random_string.resource_code.result}"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  sku_name              = "S0"
  tags                  = var.tags
  deployments           = var.deployments
  custom_subdomain_name = "${var.name}aiservices${random_string.resource_code.result}"
}
