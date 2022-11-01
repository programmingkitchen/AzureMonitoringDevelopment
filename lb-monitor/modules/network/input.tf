# Resource Group
variable rg_name {}
variable "location" {}

# Netork
variable "vnet_name" {}
variable "vnet_address_space" {}
variable "subnet_a_address_space" {}
variable "subnet_b_address_space" {}

# Tags
variable "tags" {
  type = map(string)
}