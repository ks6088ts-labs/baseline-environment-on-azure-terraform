output "resource_group_name" {
  value       = module.resource_group.name
  description = "created resource group name"
}

output "ai_services_endpoint" {
  value       = module.ai_services.endpoint
  description = "Specifies the endpoint of the Azure AI Service"
}

output "ai_services_primary_access_key" {
  value       = module.ai_services.primary_access_key
  description = "Specifies the primary access key of the Azure AI Service."
  sensitive   = true
}
