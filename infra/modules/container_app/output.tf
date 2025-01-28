output "id" {
  value       = azurerm_container_app.container_app.id
  description = "Specifies the resource id"
}

output "name" {
  value       = azurerm_container_app.container_app.name
  description = "Specifies the name of the Azure Container Apps"
}

output "fqdn" {
  value       = azurerm_container_app.container_app.latest_revision_fqdn
  description = "Specifies the FQDN of the Azure Container Apps"
}
