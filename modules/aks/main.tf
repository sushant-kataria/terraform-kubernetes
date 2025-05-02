
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name                = var.system_node_pool.name
    node_count          = var.system_node_pool.node_count
    vm_size             = var.system_node_pool.vm_size
    os_disk_size_gb     = var.system_node_pool.os_disk_size_gb
    max_pods            = var.system_node_pool.max_pods
    zones               = var.system_node_pool.zones
    type                = "VirtualMachineScaleSets"
    vnet_subnet_id      = var.vnet_subnet_id
    orchestrator_version = var.kubernetes_version
      auto_scaling_enabled = var.user_node_pool.enable_auto_scaling
  min_count             = var.user_node_pool.min_count
  max_count             = var.user_node_pool.max_count
  }

  identity {
    type = var.identity_type
  }

  network_profile {
    network_plugin      = var.network_profile.network_plugin
    network_policy      = var.network_profile.network_policy
    load_balancer_sku   = var.network_profile.load_balancer_sku
    network_plugin_mode = var.network_profile.network_plugin_mode
    service_cidr         = var.service_cidr
  dns_service_ip       = var.dns_service_ip
  }

  oidc_issuer_enabled       = var.enable_oidc
  workload_identity_enabled = var.enable_workload_identity
  azure_policy_enabled      = var.enable_azure_policy

  tags = var.tags
}

resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                  = var.user_node_pool.name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = var.user_node_pool.vm_size
  node_count            = var.user_node_pool.node_count
  os_disk_size_gb       = var.user_node_pool.os_disk_size_gb
  max_pods              = var.user_node_pool.max_pods
  vnet_subnet_id        = var.vnet_subnet_id
  mode                  = "User"
  zones                 = var.user_node_pool.zones
  orchestrator_version  = var.kubernetes_version

  auto_scaling_enabled = var.user_node_pool.enable_auto_scaling
  min_count             = var.user_node_pool.min_count
  max_count             = var.user_node_pool.max_count

  depends_on = [azurerm_kubernetes_cluster.aks]
}
