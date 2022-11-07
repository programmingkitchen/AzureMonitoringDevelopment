
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
  name                = "${var.ag_name}"
  resource_group_name = "${var.rg_name}"
  short_name          = "${var.short_name}"

  webhook_receiver {
    name        = "${var.webhook_name}"
    service_uri = "${var.service_uri}"
  }
  tags                   = "${var.tags}"
}


# https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-supported
# Microsoft.Network/loadBalancers
resource "azurerm_monitor_metric_alert" "lbhealth" {
  name                = "MonitorTest-metricalert"
  resource_group_name = "${var.rg_name}"
  scopes              = ["${var.lb_id}"]
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


/*
resource "azurerm_monitor_metric_alert" "webhealth" {
  name                = "MonitorTest-metricalert"
  resource_group_name = "${var.rg_name}"
  scopes              = ["${var.lb_id}"]
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

*/
