output "kubelet_identity" {
  value = module.aks.kubelet_identity[0]
}
