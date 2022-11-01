variable "location" {}
variable "rg_name" {}
variable "nic_name" {}
variable "subnet_id" {}
variable "pip_id" {}
variable "vm_name" {}
variable "username" {}
variable "public_key" {}


# Tags
variable "tags" {
  type = map(string)
}