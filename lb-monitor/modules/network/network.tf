resource "azurerm_virtual_network" "main" {
  resource_group_name = "${var.rg_name}"
  name                = "${var.vnet_name}"
  location            = "${var.location}"
  address_space       = ["${var.vnet_address_space}"]
  tags                = "${var.tags}"
  
}


resource "azurerm_subnet" "frontend" {
  name                 = "SubnetA-frontend"
  resource_group_name  = "${var.rg_name}"
  #resource_group_name = resource_group.azurerm_resource_group.test.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_a_address_space]
}

resource "azurerm_subnet" "backend" {
  name                 = "SubnetB-backend"
  resource_group_name  = "${var.rg_name}"
  #resource_group_name = resource_group.azurerm_resource_group.test.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_b_address_space]
}
