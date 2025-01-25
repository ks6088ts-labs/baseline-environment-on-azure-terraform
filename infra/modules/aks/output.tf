output "id" {
  value       = azurerm_kubernetes_cluster.aks_cluster.id
  description = "Specifies the resource id"
}

output "name" {
  value       = azurerm_kubernetes_cluster.aks_cluster.name
  description = "Specifies the name of the Azure Kubernetes Service"
}
