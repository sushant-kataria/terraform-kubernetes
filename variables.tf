variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
variable "acr_name" { type = string }
variable "acr_sku" {
  type    = string
  default = "Standard"
}
variable "acr_admin_enabled" {
  type    = bool
  default = false
}

variable "cluster_name" { type = string }
variable "dns_prefix" { type = string }
variable "kubernetes_version" { type = string }

variable "default_node_pool" {
  type = object({
    name                 = string
    vm_size              = string
    enable_auto_scaling  = bool
    min_count            = number
    max_count            = number
    max_pods             = number
    os_disk_size_gb      = number
    zones                = list(string)
    orchestrator_version = string
  })
}
variable "network_profile" {
  type = object({
    network_plugin      = string
    network_policy      = string
    load_balancer_sku   = string
    network_plugin_mode = string
  })
}
variable "identity_type" { type = string }
# variable "vnet_subnet_id" { type = string }
variable "enable_workload_identity" { type = bool }
variable "enable_oidc" { type = bool }
variable "enable_azure_policy" { type = bool }

variable "vnet_name" { type = string }
variable "vnet_address_space" { type = list(string) }
variable "aks_subnet_name" { type = string }
variable "aks_subnet_address_prefix" { type = list(string) }
variable "endpoints_subnet_name" { type = string }
variable "endpoints_subnet_address_prefix" { type = list(string) }


variable "system_node_pool" {
  type = any
}

variable "user_node_pool" {
  type = any
}

variable "service_cidr" {
  type        = string
  description = "CIDR range for Kubernetes services"
}

variable "dns_service_ip" {
  type        = string
  description = "DNS IP address within the service CIDR"
}

variable "subscription_id" {
  description = "The Azure subscription ID."
  type        = string
}

# variables.tf in the root module
variable "terraform_principal_id" {
  description = "The object ID of the Terraform identity (e.g., service principal)."
  type        = string
}