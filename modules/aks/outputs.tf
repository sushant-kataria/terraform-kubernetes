output "cluster_id" {
  value = azurerm_kubernetes_cluster.aks.id
}
output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}
output "cluster_fqdn" {
  value = azurerm_kubernetes_cluster.aks.fqdn
}
output "kubelet_identity" {
  value = azurerm_kubernetes_cluster.aks.kubelet_identity
}

