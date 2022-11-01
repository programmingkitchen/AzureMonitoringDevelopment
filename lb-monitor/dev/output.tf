output "lb_pip_ip" {
  value = "${module.loadbalancer.lb_pip_addr}"
}

output "pip_ip" {
  value = "${module.pip.ip_address}"
}

output "jump_pip" {
  value = "${module.jumpvm.vm_pip}"
}

output "jump_private_ip" {
  value = "${module.jumpvm.vm_private_ip}"
}

output "webserver_private_ip" {
  value = "${module.webserver.vm_private_ip}"
}

output "tls_private_key" {
  value = "${module.webserver.tls_private_key}"
  sensitive = true
}
