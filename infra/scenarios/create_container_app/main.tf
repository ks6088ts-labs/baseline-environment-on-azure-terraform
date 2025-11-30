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

# Resource Group
import {
  id = "/subscriptions/<サブスクリプションID>/resourceGroups/YOUR_RESOURCE_GROUP_NAME"
  to = azurerm_resource_group.rg
}

# Container App Environment
import {
  id = "/subscriptions/<サブスクリプションID>/resourceGroups/YOUR_RESOURCE_GROUP_NAME/providers/Microsoft.App/managedEnvironments/YOUR_CONTAINER_APP_ENVIRONMENT_NAME"
  to = azurerm_container_app_environment.env
}

# Container App
import {
    id = "/subscriptions/<サブスクリプションID>/resourceGroups/YOUR_RESOURCE_GROUP_NAME/providers/Microsoft.App/containerApps/YOUR_CONTAINER_APP_NAME"
    to = azurerm_container_app.app
}
