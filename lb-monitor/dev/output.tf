output "lb_pip_ip" {
  value = "${module.loadbalancer.lb_pip_addr}"
}

output "pip_ip" {
  value = "${module.pip.ip_address}"
}

output "lb_id" {
  value = "${module.loadbalancer.lb_id}"
}
