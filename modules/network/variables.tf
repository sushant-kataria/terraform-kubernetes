variable "vnet_name" {
  type = string
}
variable "vnet_address_space" {
  type = list(string)
}
variable "aks_subnet_name" {
  type = string
}
variable "aks_subnet_address_prefix" {
  type = list(string)
}
variable "endpoints_subnet_name" {
  type = string
}
variable "endpoints_subnet_address_prefix" {
  type = list(string)
}
variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}
variable "tags" {
  type    = map(string)
  default = {}
}