# Monitoring
variable "rg_name" {}
variable "ag_name" {}
variable "short_name" {}
variable "webhook_name" {}
variable "service_uri" {}
variable "lb_id" {}

# Tags
variable "tags" {
  type = map(string)
}
