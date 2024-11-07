output "id" {
  value       = azurerm_storage_account.storage_account.id
  description = "Specifies the resource id of the storage account"
}

output "location" {
  value       = azurerm_storage_account.storage_account.location
  description = "Specifies the location of the resource group"
}

output "storage_account_name" {
  value       = azurerm_storage_account.storage_account.name
  description = "Specifies the name of the storage account"
}

output "storage_container_name" {
  value       = azurerm_storage_container.storage_container.name
  description = "Specifies the name of the storage container"
}
