# Resource Group
variable location {}
variable "rg_name" {}
# Tags
variable "tags" {
  type = map(string)
}