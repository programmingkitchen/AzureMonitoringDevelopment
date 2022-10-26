# Load Balancer
variable "location" {}
variable "rg_name" {}
variable "lb_name" {}
variable "app_port" {}

# Tags
variable "tags" {
  type = map(string)
}
