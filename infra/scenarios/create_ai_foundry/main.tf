terraform {
  required_version = ">= 1.6.0"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "2.4.0"
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

provider "azapi" {}

locals {
  ai_services_name = "${var.name}${module.random.random_string}"
}

module "random" {
  source = "../../modules/random"

  length  = 5
  special = false
  upper   = false
}

module "resource_group" {
  source = "../../modules/resource_group"

  name     = "rg-${var.name}-${module.random.random_string}"
  location = var.location
  tags     = var.tags
}

resource "azapi_resource" "account" {
  type      = "Microsoft.CognitiveServices/accounts@2025-04-01-preview"
  name      = "${local.ai_services_name}-account"
  parent_id = module.resource_group.id
  identity {
    type = "SystemAssigned"
    identity_ids = [
    ]
  }
  location = var.location
  tags     = var.tags
  body = {
    kind = "AIServices"
    properties = {
      allowProjectManagement = true
      customSubDomainName    = local.ai_services_name
    }
    sku = {
      name = "S0"
    }
  }
}

resource "azapi_resource" "project" {
  type      = "Microsoft.CognitiveServices/accounts/projects@2025-04-01-preview"
  name      = "${local.ai_services_name}-project"
  parent_id = azapi_resource.account.id
  identity {
    type         = "SystemAssigned"
    identity_ids = []
  }
  location = var.location
  tags     = var.tags
  body = {
    properties = {
      description = "AI Foundry Project"
      displayName = var.name
    }
  }
}
