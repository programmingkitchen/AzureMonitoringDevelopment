# NIC for the VM (includes PIP for direct access)
resource "azurerm_network_interface" "main" {
    name                = "${var.nic_name}"
    location            = "${var.location}"
    resource_group_name = "${var.rg_name}"

  ip_configuration {
      name                          = "NIC-config"
      subnet_id                     = "${var.subnet_id}"
      private_ip_address_allocation = "Dynamic"
    }
     
    tags = "${var.tags}"
}


# Create (and display) an SSH key
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Virtual machine
# Use a local key on desktop for accessing jump so we don't have to add to 
# new SecureCRT config.
resource "azurerm_linux_virtual_machine" "main" {
  name                    = "${var.vm_name}"
  location                = "${var.location}"
  resource_group_name     = "${var.rg_name}"
  size                            = "Standard_B1s"
  #size                            = "Standard_DS1_v2"
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  source_image_id = "/subscriptions/ec6a8ad6-a9e3-4cf9-8ff6-76cb07aeff66/resourceGroups/MyImages-rg-01/providers/Microsoft.Compute/images/Ubuntu18Nginx-img-01"

  computer_name                   = "${var.vm_name}"
  admin_username                  = "${var.username}"
  disable_password_authentication = true

  admin_ssh_key {
    username = "${var.username}"
    public_key = tls_private_key.example_ssh.public_key_openssh
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
  tags = var.tags
}





