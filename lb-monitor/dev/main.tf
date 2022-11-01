provider "azurerm" {
  tenant_id       = "${var.tenant_id}"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  features {}
}

# Resource group and Storage Account created manually.
terraform {
  backend "azurerm" {
    resource_group_name =   "UdacityProject3.1"
    storage_account_name = "udacity31granier"
    container_name       = "terraform"
    key                  = "dev.terraform.tfstate"
    access_key           = "oycYkgonJsdKObg/DCdUIBW9Of/SGLgyy/iYRrXjPWhKtDEGt3vilSWqxKUsQtumRsFWRLe4Gu2K+AStacmOKg=="
  }
}

# Resource Group
module "resource_group" {
  source            = "../modules/resource_group"
  location          = "${var.location}"
  rg_name           = "${var.prefix}-${var.rg_name}"
  tags             =  "${var.tags}"
}

 #resource_group_name = module.resource_group.azurerm_resource_group.test.name

# vNET 
module "network" {
  source            = "../modules/network"
  rg_name           = "${module.resource_group.resource_group_name}"
  location          = "${module.resource_group.resource_group_location}"
  vnet_name         = "${var.vnet_name}"
  vnet_address_space     = "${var.vnet_address_space}"
  subnet_a_address_space = "${var.subnet_a_address_space}"
  subnet_b_address_space = "${var.subnet_b_address_space}"
  tags              = "${var.tags}"
  depends_on = [module.resource_group]
}


# NSG 
module "nsg" {
  source            = "../modules/nsg"
  rg_name           = "${module.resource_group.resource_group_name}"
  location          = "${module.resource_group.resource_group_location}"
  application_port  = "${var.application_port}"
  tags              = "${var.tags}"
  depends_on = [module.resource_group]
}

# Connect NSG to the Frontend subnet
# Decouple linking resources from the creation of the resources (components)
resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id      = module.network.frontend_id
  network_security_group_id = module.nsg.nsg_id
}


# Public IP
# How do we make more than one?
module "pip" {
  source       = "../modules/pip"
  location     = "${module.resource_group.resource_group_location}"
  rg_name      = "${module.resource_group.resource_group_name}"
  name         = "${var.prefix}-${var.pip_name}"
  tags         =  "${var.tags}"
}


#LB

module "loadbalancer" {
  source       = "../modules/loadbalancer"
  lb_name       = "${var.lb_name}"
  location      = "${module.resource_group.resource_group_location}"
  rg_name       = "${module.resource_group.resource_group_name}"
  application_port      = "${var.application_port}"
  tags         =  "${var.tags}"
  depends_on    = [module.resource_group, module.pip]
  
}


# Associate the webserver NIC with the BEP.  We need to refer to the ip config name on the nic
resource "azurerm_network_interface_backend_address_pool_association" "main" {
  network_interface_id    = "${module.webserver.nic_id}"
  ip_configuration_name   = "${module.webserver.ip_config_name}"
  backend_address_pool_id = "${module.loadbalancer.bep_id}"
}


# VM
module "jumpvm" {
  source       = "../modules/jumpvm"
  
  # NIC info
  location     = "${module.resource_group.resource_group_location}"
  rg_name      = "${module.resource_group.resource_group_name}"
  nic_name     = "${var.prefix}-${var.nic_name}"
  subnet_id    = "${module.network.frontend_id}"
  pip_id       = "${module.pip.pip_id}"
  
  vm_name         = "${var.prefix}-${var.vm_name}"
  username        = "${var.username}"
  public_key      = file("${var.public_key}")
  tags         =  "${var.tags}"
}

# VM
module "webserver" {
  source       = "../modules/webserver"
  
  # NIC info
  location     = "${module.resource_group.resource_group_location}"
  rg_name      = "${module.resource_group.resource_group_name}"
  nic_name     = "${var.prefix}-${var.web_nic_name}"
  subnet_id    = "${module.network.frontend_id}"
  
  vm_name         = "${var.prefix}-${var.web_vm_name}"
  username        = "${var.username}"
  tags         =  "${var.tags}"
}
