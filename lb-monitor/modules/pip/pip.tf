/*
  Decoupled PIP
  Create public IPs
  Create more than one PIP by passing in different vars.  We can add a new module, e.g. pip2
  
*/
resource "azurerm_public_ip" "main" {
  name                = "${var.name}"
  location            = "${var.location}"
  resource_group_name = "${var.rg_name}"
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = "${var.tags}"
}