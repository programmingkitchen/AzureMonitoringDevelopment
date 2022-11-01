output "nic_id" {
  value = "${azurerm_network_interface.main.id}"
}

output "ip_config_name" {
  value = "${azurerm_network_interface.main.ip_configuration[0].name}"
}

output "vm_private_ip" {
  value = "${azurerm_linux_virtual_machine.main.private_ip_address}"
}

output "tls_private_key" {
  value     = tls_private_key.example_ssh.private_key_pem
  sensitive = true
}