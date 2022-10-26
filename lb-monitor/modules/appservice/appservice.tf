resource "azurerm_service_plan" "test" {
  name                = "${var.application_name}-${var.resource_type}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"
  os_type             = "Linux"
  sku_name            = "P1v2"
  tags = "${var.tags}"
}

resource "azurerm_linux_web_app" "test" {
  name                = "${var.application_name}-${var.resource_type}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"
  service_plan_id     = azurerm_service_plan.test.id

  site_config {}

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = 0
  }

  tags = "${var.tags}"
}