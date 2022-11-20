# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }
  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "main" {
  location          = "${var.location}"
  name           = "${var.prefix}-${var.rg_name}"
  tags             =  "${var.tags}"
}

resource "azurerm_monitor_action_group" "main" {
  name                = "${var.prefix}-ActionGroup-01"
  resource_group_name = azurerm_resource_group.main.name
  short_name          = "AG testing"

  webhook_receiver {
    name        = "${var.prefix}-SecureWebhook-rg9133"
    service_uri = "https://attdistdev2.service-now.com/api/sn_em_connector/em/inbound_event?source=azuremonitor"
    use_common_alert_schema = true
    aad_auth {
      object_id = "276ae8d9-1101-4d50-9720-5a782a52d269"
    }
  }
  tags                   = "${var.tags}"
}

/*
  LB Health Probe Status
  # https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-supported
  # Microsoft.Network/loadBalancers
*/
resource "azurerm_monitor_metric_alert" "main" {
  name                = "${var.prefix}-healthprobe"
  resource_group_name = azurerm_resource_group.main.name
  scopes              = ["${var.lb_id}"]
  description         = "Terrafrom Health Status on LB"
  severity            = 0

  criteria {
    metric_namespace = "Microsoft.Network/loadBalancers"
    metric_name      = "DipAvailability"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 75
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
  tags                   = "${var.tags}"
}

resource "azurerm_monitor_metric_alert" "packetcount" {
  name                = "${var.prefix}-PacketCount"
  resource_group_name = azurerm_resource_group.main.name
  scopes              = ["${var.lb_id}"]
  description         = "Packet Count on LB West"
  severity            = 3

  criteria {
    metric_namespace = "Microsoft.Network/loadBalancers"
    metric_name      = "PacketCount"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 500
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
  tags                   = "${var.tags}"
}

# Availability of FW
resource "azurerm_monitor_metric_alert" "fw01" {
  name                = "${var.prefix}-FW01-Availability"
  resource_group_name = azurerm_resource_group.main.name
  scopes              = ["${var.fw01_id}"]
  description         = "FW availability."

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

# Resource Health of FW
resource "azurerm_monitor_activity_log_alert" "main" {
  name                = "${var.prefix}-FW01-ResourceHealth"
  resource_group_name = azurerm_resource_group.main.name
  scopes              = ["${var.fw01_id}"]
  description         = "Resource health on FW01."

  criteria {
    category       = "ResourceHealth"

    resource_health {
      current = ["Degraded", "Unavailable", "Unknown"]
      previous = ["Degraded", "Unavailable", "Unknown"]
      reason = ["PlatformInitiated", "Unknown"]
    }
  }
   action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
   tags                   = "${var.tags}"
}