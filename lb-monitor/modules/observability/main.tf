
/* 
 https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group
 webhook_receiver {
    name                    = "callmyapiaswell"
    service_uri             = "http://example.com/alert"
    use_common_alert_schema = true
  }

add_auth
*/

resource "azurerm_monitor_action_group" "main" {
  name                = "MonitorTest-ag"
  resource_group_name = "${var.rg_name}"
  short_name          = "Randall-ag"

  webhook_receiver {
    name        = "callmyapi"
    service_uri = "http://example.com/alert"
  }
  tags                   = "${var.tags}"
}

# https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-supported
# Microsoft.Network/loadBalancers
resource "azurerm_monitor_metric_alert" "example" {
  name                = "MonitorTest-metricalert"
  resource_group_name = "${var.rg_name}"
  scopes              = [azurerm_lb.main.id]
  description         = "Some Message."

  criteria {
    metric_namespace = "Microsoft.Network/loadBalancers"
    metric_name      = "DipAvailability"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 100
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
  tags                   = "${var.tags}"
}
