resource_group_name = "AKS1"
location            = "eastus2"
acr_name            = "demoakscr2111"
acr_sku             = "Standard"
acr_admin_enabled   = false

cluster_name       = "demoaks"
dns_prefix         = "demoaks-dns"
kubernetes_version = "1.30.0"

default_node_pool = {
  name                 = "sp"
  vm_size              = "Standard_D2s_v3"
  enable_auto_scaling  = true
  min_count            = 1
  max_count            = 2
  max_pods             = 110
  os_disk_size_gb      = 30
  zones                = ["1", "2"]
  orchestrator_version = "1.30.0"
}

network_profile = {
  network_plugin      = "azure"
  network_policy      = "calico"
  load_balancer_sku   = "standard"
  network_plugin_mode = "overlay"
}

identity_type            = "SystemAssigned"
enable_workload_identity = true
enable_oidc              = true
enable_azure_policy      = false

tags                            = {}
vnet_name                       = "aks-vnet"
vnet_address_space              = ["10.0.0.0/16"]
aks_subnet_name                 = "aks-subnet"
aks_subnet_address_prefix       = ["10.0.1.0/24"]
endpoints_subnet_name           = "endpoints-subnet"
endpoints_subnet_address_prefix = ["10.0.2.0/24"]


system_node_pool = {
  name                = "systemnp"
  node_count          = 1
  vm_size             = "Standard_D2s_v3"
  os_disk_size_gb     = 30
  max_pods            = 110
  zones               = ["1", "2"]
  enable_auto_scaling = true
  min_count           = 1
  max_count           = 3
}

user_node_pool = {
  name                = "usernp"
  vm_size             = "Standard_D2s_v3"
  node_count          = 1
  os_disk_size_gb     = 30
  max_pods            = 110
  zones               = ["1", "2"]
  enable_auto_scaling = true
  min_count           = 1
  max_count           = 3
}

service_cidr   = "10.240.0.0/16"
dns_service_ip = "10.240.0.10"
subscription_id = "d1fc1672-f56d-4f3d-b6ab-0f725d80bef1"
terraform_principal_id = "6f5bdb69-a72e-43af-9490-ebb4a0545054"