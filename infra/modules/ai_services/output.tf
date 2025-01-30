output "id" {
  value       = azurerm_ai_services.ai_services.id
  description = "Specifies the resource id"
}

output "name" {
  value       = azurerm_ai_services.ai_services.name
  description = "Specifies the name of the Azure AI Service"
}

output "endpoint" {
  value       = azurerm_ai_services.ai_services.endpoint
  description = "Specifies the endpoint of the Azure AI Service"
}

output "primary_access_key" {
  value       = azurerm_ai_services.ai_services.primary_access_key
  description = "Specifies the primary access key of the Azure AI Service."
  sensitive   = true
}

output "secondary_access_key" {
  value       = azurerm_ai_services.ai_services.secondary_access_key
  description = "Specifies the secondary access key of the Azure AI Service."
  sensitive   = true
}
