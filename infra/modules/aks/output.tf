output "id" {
  value       = azurerm_kubernetes_cluster.aks_cluster.id
  description = "Specifies the resource id"
}

output "name" {
  value       = azurerm_kubernetes_cluster.aks_cluster.name
  description = "Specifies the name of the Azure Kubernetes Service"
}

output "host" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.host
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_certificate
}

output "client_key" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_key
}

output "cluster_ca_certificate" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.cluster_ca_certificate
}
