# Azure GUIDS
variable "subscription_id" {
    description = "Subscription id"
}
variable "client_id" {
    description = "Client id"
}
variable "client_secret" {
    description = "Client secret"
}
variable "tenant_id" {
    description = "Tenant id"
}

# Resource
variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
}

variable "rg_name" {
    description = "The name of the resource group."
}

# Network
variable "vnet_name" {
  description = "Vnet name "
}

variable "vnet_address_space" {
  description = "Vnet address space "
}

variable "subnet_a_address_space" {
  description = "Subnet A (frontend)"
}

variable "subnet_b_address_space" {
  description = "Subnet B (backend)"
}

# Public IP Addresses
variable "pip_name" {
}

# Load Balancer

variable "lb_name" {}
variable "app_port" {}


# Application
variable "application_name" {}
variable "application_port" {}

variable "tags" {
   description = "Map of the tags to use for the resources that are deployed"
   type        = map(string)
}
