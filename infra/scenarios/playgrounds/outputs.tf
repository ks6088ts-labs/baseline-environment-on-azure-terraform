output "resource_group_name" {
  value       = module.resource_group.name
  description = "created resource group name"
}

output "aks_cluster_name" {
  value       = module.aks.name
  description = "created Azure Kubernetes Service name"
}
