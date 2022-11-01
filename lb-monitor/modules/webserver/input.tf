variable "location" {}
variable "rg_name" {}
variable "nic_name" {}
variable "subnet_id" {}
variable "vm_name" {}
variable "username" {}

# Tags
variable "tags" {
  type = map(string)
}