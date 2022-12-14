
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
    use_common_alert_schema = true
    add_auth {
      object_id = "276ae8d9-1101-4d50-9720-5a782a52d269"
    }
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



resource "azurerm_monitor_metric_alert" "webavail" {
  name                = "MonitorTest-VMAvailability"
  resource_group_name = "${var.rg_name}"
  scopes              = ["${var.vm_id}"]
  description         = "Some Message.  Test availability."

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "VMAvailabilityMetric"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 100
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
  tags                   = "${var.tags}"
}


