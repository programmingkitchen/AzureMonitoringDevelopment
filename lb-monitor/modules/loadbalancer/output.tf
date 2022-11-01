output "lb_pip_addr" {
  value = "${azurerm_public_ip.main.ip_address}"
}

output "lb_id" {
  value = "${azurerm_lb.main.id}"
}

output "bep_id" {
  value = "${azurerm_lb_backend_address_pool.main.id}"
}


