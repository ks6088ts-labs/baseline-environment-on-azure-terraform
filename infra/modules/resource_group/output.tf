output "id" {
  value       = azurerm_resource_group.rg.id
  description = "Specifies the resource id of the resource group"
}

output "name" {
  value       = azurerm_resource_group.rg.name
  description = "Specifies the resource name of the resource group"
}
