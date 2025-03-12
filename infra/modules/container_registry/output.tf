output "id" {
  value       = azurerm_container_registry.container_registry.id
  description = "Specifies the resource id"
}

output "name" {
  value       = azurerm_container_registry.container_registry.name
  description = "Specifies the name of the Azure Container Registry"
}
