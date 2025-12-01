# Resource Group
output "resource_group_id" {
  description = "リソースグループの ID"
  value       = azurerm_resource_group.rg.id
}

# Container App Environment
output "container_app_environment_id" {
  description = "Container App Environment の ID"
  value       = azurerm_container_app_environment.env.id
}

# Container App
output "container_app_id" {
  description = "Container App の ID"
  value       = azurerm_container_app.app.id
}

output "container_app_fqdn" {
  description = "Container App の FQDN (外部アクセス URL)"
  value       = azurerm_container_app.app.ingress[0].fqdn
}

output "container_app_latest_revision_name" {
  description = "Container App の最新リビジョン名"
  value       = azurerm_container_app.app.latest_revision_name
}
