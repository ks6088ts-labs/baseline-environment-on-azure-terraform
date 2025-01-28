output "id" {
  value       = module.container_app.id
  description = "Specifies the resource id"
}

output "name" {
  value       = module.container_app.name
  description = "Specifies the name of the Azure Container Apps"
}

output "fqdn" {
  value       = module.container_app.fqdn
  description = "Specifies the FQDN of the Azure Container Apps"
}
