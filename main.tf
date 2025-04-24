module "resource_group" {
  source = "git::https://bitbucket.org/shaurya123/azure-aks-modules.git//modules/resource_group?ref=main"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

module "acr" {
  source              = "git::https://bitbucket.org/shaurya123/azure-aks-modules.git//modules/acr?ref=main"
  name                = var.acr_name
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  sku                 = var.acr_sku
  admin_enabled       = var.acr_admin_enabled
  tags                = var.tags
  depends_on          = [module.resource_group]
}


module "network" {
 source = "git::https://bitbucket.org/shaurya123/azure-aks-modules.git//modules/network?ref=main"
  vnet_name                       = var.vnet_name
  vnet_address_space              = var.vnet_address_space
  aks_subnet_name                 = var.aks_subnet_name
  aks_subnet_address_prefix       = var.aks_subnet_address_prefix
  endpoints_subnet_name           = var.endpoints_subnet_name
  endpoints_subnet_address_prefix = var.endpoints_subnet_address_prefix
  resource_group_name             = module.resource_group.resource_group_name
  location                        = var.location
  tags                            = var.tags

  depends_on = [module.resource_group]
}

module "aks" {
  system_node_pool    = var.system_node_pool
  user_node_pool      = var.user_node_pool
  source = "git::https://bitbucket.org/shaurya123/azure-aks-modules.git//modules/aks?ref=main"
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  cluster_name        = var.cluster_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  default_node_pool = var.default_node_pool
  network_profile   = var.network_profile
  identity_type     = var.identity_type
  vnet_subnet_id    = module.network.aks_subnet_id
  service_cidr      = var.service_cidr
  dns_service_ip    = var.dns_service_ip


  enable_workload_identity = var.enable_workload_identity
  enable_oidc              = var.enable_oidc
  enable_azure_policy      = var.enable_azure_policy
  tags                     = var.tags

  depends_on = [module.resource_group, module.acr]
}

// # Assign Owner role to the Terraform identity at the subscription level
// resource "azurerm_role_assignment" "terraform_owner" {
//   scope                = "/subscriptions/${var.subscription_id}"
//   role_definition_name = "Owner"
//   principal_id         = var.terraform_principal_id # Replace with the object ID of the Terraform identity
// }

resource "azurerm_role_assignment" "aks_acr_pull" {
  role_definition_name = "AcrPull"
  principal_id         = module.aks.kubelet_identity[0].object_id
  scope                = module.acr.acr_id
  // scope                 = azurerm_container_registry.acr.id
  depends_on           = [module.aks, module.acr]
}
