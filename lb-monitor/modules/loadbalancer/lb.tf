resource "azurerm_public_ip" "main" {
  name                = "PublicIPForLB"
  location            = "${var.location}"
  resource_group_name = "${var.rg_name}"
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = "${var.tags}"
}


# Create a LB (Standard sku requiered for Standard sku IP)
resource "azurerm_lb" "main" {
  name                = "${var.lb_name}"
  location            = "${var.location}"
  resource_group_name = "${var.rg_name}"
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "fe-01"
    public_ip_address_id = azurerm_public_ip.main.id
  }
  tags                   = "${var.tags}"
}


# Create backend pool
resource "azurerm_lb_backend_address_pool" "main" {
 loadbalancer_id     = azurerm_lb.main.id
 name                = "bep-01"
}

# Health Probe
resource "azurerm_lb_probe" "main" {
 loadbalancer_id     = azurerm_lb.main.id
 name                = "http-running-probe"
 port                = "${var.application_port}"
}

# LB Rule
resource "azurerm_lb_rule" "main" {
   loadbalancer_id                = azurerm_lb.main.id
   name                           = "http"
   protocol                       = "Tcp"
   frontend_port                  = "${var.application_port}"
   backend_port                   = "${var.application_port}"
   backend_address_pool_ids       = [azurerm_lb_backend_address_pool.main.id, ]
   frontend_ip_configuration_name = "fe-01"
   probe_id                       = azurerm_lb_probe.main.id
   disable_outbound_snat          = true
}

# Outbound rule
# The rule above does not not automatically add the outbound rule
resource "azurerm_lb_outbound_rule" "main" {
  name                      = "OutboundRule"
  loadbalancer_id           = azurerm_lb.main.id
  protocol                  = "Tcp"
  backend_address_pool_id   = azurerm_lb_backend_address_pool.main.id

  frontend_ip_configuration {
    name = "fe-01"
  }
}

