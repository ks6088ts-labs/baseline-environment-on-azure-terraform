terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0.2"
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

data "azurerm_subscription" "primary" {
}

locals {
  subscription_id = data.azurerm_subscription.primary.id
}

module "subscription_policy_assignment" {
  source = "../../modules/subscription_policy_assignment"

  name                 = var.name
  policy_definition_id = var.policy_definition_id
  subscription_id      = local.subscription_id
}
