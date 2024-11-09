output "service_principal_client_id" {
  value       = azuread_service_principal.service_principal.client_id
  description = "Service Principal Client ID"
}

output "application_object_id" {
  value       = azuread_application.application.object_id
  description = "Application Object ID"
}

output "tenant_id" {
  value       = data.azuread_client_config.client_config.tenant_id
  description = "Tenant ID"
}

output "service_principal_password" {
  value     = azuread_service_principal_password.service_principal_password.value
  sensitive = true
}
