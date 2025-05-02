variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}
variable "cluster_name" {
  type = string
}
variable "dns_prefix" {
  type = string
}
variable "kubernetes_version" {
  type = string
}
variable "default_node_pool" {
  type = object({
    name                = string
    vm_size             = string
    enable_auto_scaling = bool
    min_count           = number
    max_count           = number
    max_pods            = number
    os_disk_size_gb     = number
    zones               = list(string)
    orchestrator_version = string
   
  })
}
variable "network_profile" {
  type = object({
    network_plugin     = string
    network_policy     = string
    load_balancer_sku  = string
    network_plugin_mode = string
  })
}
variable "identity_type" {
  type = string
}
variable "vnet_subnet_id" {
  type = string
}
variable "enable_workload_identity" {
  type = bool
}
variable "enable_oidc" {
  type = bool
}
variable "enable_azure_policy" {
  type = bool
}
variable "tags" {
  type    = map(string)
  default = {}
}

variable "system_node_pool" {
  type = object({
    name             = string
    node_count       = number
    vm_size          = string
    os_disk_size_gb  = number
    max_pods         = number
    zones            = list(string)
    enable_auto_scaling = bool
    min_count           = number
    max_count           = number
  
  })
}

variable "user_node_pool" {
  type = object({
    name                = string
    vm_size             = string
    node_count          = number
    os_disk_size_gb     = number
    max_pods            = number
    zones               = list(string)
    enable_auto_scaling = bool
    min_count           = number
    max_count           = number
  })
}

variable "service_cidr" {
  description = "The CIDR to use for Kubernetes services"
  type        = string
}

variable "dns_service_ip" {
  description = "The IP address within the service CIDR for DNS service"
  type        = string
}
