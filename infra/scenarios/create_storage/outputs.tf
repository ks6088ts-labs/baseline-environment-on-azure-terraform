output "resource_group_name" {
  value       = azurerm_resource_group.rg.name
  description = "created resource group name"
}

output "storage_account_name" {
  value       = azurerm_storage_account.sa.name
  description = "created storage account name"
}

output "container_name" {
  value       = azurerm_storage_container.sc.name
  description = "created container name"
}
