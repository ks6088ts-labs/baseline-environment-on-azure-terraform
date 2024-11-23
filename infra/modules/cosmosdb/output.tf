output "id" {
  value       = azurerm_cosmosdb_account.cosmosdb_account.id
  description = "Specifies the resource id of the cosmosdb account"
}

output "location" {
  value       = azurerm_cosmosdb_account.cosmosdb_account.location
  description = "Specifies the location of the resource group"
}

output "cosmosdb_account_name" {
  value       = azurerm_cosmosdb_account.cosmosdb_account.name
  description = "Specifies the name of the cosmosdb account"
}

output "cosmosdb_sql_database_name" {
  value       = azurerm_cosmosdb_sql_database.cosmosdb_sql_database.name
  description = "Specifies the name of the storage container"
}

output "cosmosdb_sql_container_name" {
  value       = azurerm_cosmosdb_sql_container.cosmosdb_sql_container.name
  description = "Specifies the name of the storage container"
}
