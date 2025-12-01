# Resource Group
resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = var.resource_group_name
  tags     = var.tags
}

# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "law" {
  location            = azurerm_resource_group.rg.location
  name                = var.log_analytics_workspace_name
  resource_group_name = azurerm_resource_group.rg.name
  retention_in_days   = var.log_analytics_retention_in_days
  sku                 = "PerGB2018"
  tags                = var.tags
}

# Container App Environment
resource "azurerm_container_app_environment" "env" {
  location                   = azurerm_resource_group.rg.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  name                       = var.container_app_environment_name
  resource_group_name        = azurerm_resource_group.rg.name
  tags                       = var.tags
}

# Container App
resource "azurerm_container_app" "app" {
  container_app_environment_id = azurerm_container_app_environment.env.id
  name                         = var.container_app_name
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"
  tags                         = var.tags

  ingress {
    external_enabled = true
    target_port      = var.container_target_port
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  template {
    max_replicas = var.container_max_replicas
    min_replicas = var.container_min_replicas

    container {
      args    = var.container_args
      command = var.container_command
      cpu     = var.container_cpu
      image   = var.container_image
      memory  = var.container_memory
      name    = var.container_app_name

      dynamic "env" {
        for_each = var.container_env_vars
        content {
          name  = env.value.name
          value = env.value.value
        }
      }
    }
  }
}
