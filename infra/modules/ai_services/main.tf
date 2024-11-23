terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.5.0"
    }
  }
}

resource "azurerm_ai_services" "ai_services" {
  name                  = var.name
  location              = var.location
  resource_group_name   = var.resource_group_name
  custom_subdomain_name = var.custom_subdomain_name
  sku_name              = var.sku_name
  public_network_access = "Enabled"
  tags                  = var.tags

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_cognitive_deployment" "deployment" {
  for_each = { for deployment in var.deployments : deployment.name => deployment }

  name                 = each.key
  cognitive_account_id = azurerm_ai_services.ai_services.id

  model {
    format  = "OpenAI"
    name    = each.value.model.name
    version = each.value.model.version
  }

  sku {
    name     = each.value.sku.name
    capacity = each.value.sku.capacity
  }
}
