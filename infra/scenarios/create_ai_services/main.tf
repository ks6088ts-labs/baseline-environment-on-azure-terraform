terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.5.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  ai_services_name = "aoai${var.name}${module.random.random_string}"
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

module "ai_services" {
  for_each = { for ai_services_deployment in var.ai_services_deployments : ai_services_deployment.location => ai_services_deployment }

  source                = "../../modules/ai_services"
  name                  = "${local.ai_services_name}${each.value.location}"
  location              = each.value.location
  resource_group_name   = module.resource_group.name
  sku_name              = "S0"
  tags                  = var.tags
  deployments           = each.value.deployments
  custom_subdomain_name = local.ai_services_name
}
