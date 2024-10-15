terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.0"
    }
  }
}

provider "azurerm" {
  features {}
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

module "log_analytics_workspace" {
  source              = "../../modules/log_analytics"
  name                = var.name_prefix == null ? "${random_string.prefix.result}${var.log_analytics_workspace_name}" : "${var.name_prefix}${var.log_analytics_workspace_name}"
  location            = var.location
  resource_group_name = module.resource_group.name
  solution_plan_map   = var.solution_plan_map
  tags                = var.tags
}

module "openai" {
  source                        = "../../modules/openai"
  name                          = var.name_prefix == null ? "${random_string.prefix.result}${var.openai_name}" : "${var.name_prefix}${var.openai_name}"
  location                      = var.location
  resource_group_name           = module.resource_group.name
  sku_name                      = var.openai_sku_name
  tags                          = var.tags
  deployments                   = var.openai_deployments
  custom_subdomain_name         = var.openai_custom_subdomain_name == "" || var.openai_custom_subdomain_name == null ? var.name_prefix == null ? lower("${random_string.prefix.result}${var.openai_name}") : lower("${var.name_prefix}${var.openai_name}") : lower(var.openai_custom_subdomain_name)
  public_network_access_enabled = var.openai_public_network_access_enabled
  log_analytics_workspace_id    = module.log_analytics_workspace.id
}
