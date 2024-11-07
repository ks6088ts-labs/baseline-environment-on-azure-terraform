output "client_id" {
  value       = module.service_principal.service_principal_client_id
  description = "Application client ID"
}

output "tenant_id" {
  value       = data.azuread_client_config.client_config.tenant_id
  description = "Tenant ID"
}
