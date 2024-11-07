output "resource_group_name" {
  value       = module.resource_group.name
  description = "created resource group name"
}

output "storage_account_name" {
  value       = module.storage_account.storage_account_name
  description = "created storage account name"
}

output "container_name" {
  value       = module.storage_account.storage_container_name
  description = "created container name"
}
