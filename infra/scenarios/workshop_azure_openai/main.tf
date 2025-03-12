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
      version = "~> 4.22.0"
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
  source                = "../../modules/ai_services"
  name                  = local.ai_services_name
  location              = var.location
  resource_group_name   = module.resource_group.name
  sku_name              = "S0"
  tags                  = var.tags
  deployments           = var.ai_services_deployments
  custom_subdomain_name = local.ai_services_name
}

module "bing_search" {
  count = var.create_bing_search ? 1 : 0

  source            = "../../modules/bing_search"
  name              = "bing${var.name}${module.random.random_string}"
  location          = "global"
  resource_group_id = module.resource_group.id
  sku_name          = "S1"
  tags              = var.tags
}

module "container_app_environment" {
  count = var.create_container_app ? 1 : 0

  source              = "../../modules/container_app_environment"
  name                = var.name
  location            = var.location
  tags                = var.tags
  resource_group_name = module.resource_group.name
}

module "container_app" {
  count = var.create_container_app ? 1 : 0

  source                       = "../../modules/container_app"
  name                         = var.name
  tags                         = var.tags
  image                        = var.container_app_image
  resource_group_name          = module.resource_group.name
  ingress_target_port          = var.container_app_ingress_target_port
  envs                         = var.container_app_envs
  container_app_environment_id = module.container_app_environment[0].id
}

module "cosmosdb" {
  count = var.create_cosmosdb ? 1 : 0

  source              = "../../modules/cosmosdb"
  name                = "cosmosdb${var.name}${module.random.random_string}"
  location            = var.location
  resource_group_name = module.resource_group.name
  tags                = var.tags
}
