# Create Network Security Group and rule
resource "azurerm_network_security_group" "main" {
  name                = "TEST-nsg-01"
  location            = "${var.location}"
  resource_group_name = "${var.rg_name}"
  tags = var.tags

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Flask"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "${var.application_port}"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# We have to connect NSG to the Frontend subnet
/*
resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id      = azurerm_subnet.frontend.id
  network_security_group_id = azurerm_network_security_group.main.id
}
*/
