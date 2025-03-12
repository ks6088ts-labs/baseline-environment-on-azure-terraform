terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.22.0"
    }
  }
}

resource "azurerm_container_app" "container_app" {
  name                         = "${var.name}ca"
  container_app_environment_id = var.container_app_environment_id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"
  tags                         = var.tags

  template {
    container {
      name   = "${var.name}container"
      image  = var.image
      cpu    = 0.25
      memory = "0.5Gi"

      dynamic "env" {
        for_each = var.envs
        content {
          name  = env.value.name
          value = env.value.value
        }
      }
    }
  }

  ingress {
    target_port      = var.ingress_target_port
    external_enabled = true
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}
