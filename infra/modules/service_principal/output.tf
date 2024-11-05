output "application_client_id" {
  value       = azuread_application.application.client_id
  description = "Application client ID"
}

output "application_object_id" {
  value       = azuread_application.application.object_id
  description = "Application object ID"
}

output "service_principal_client_id" {
  value       = azuread_service_principal.service_principal.client_id
  description = "Service principal client ID"
}

output "service_principal_object_id" {
  value       = azuread_service_principal.service_principal.object_id
  description = "Service principal object ID"
}
