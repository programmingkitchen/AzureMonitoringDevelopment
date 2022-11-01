# Set up monitoring on the LB 

## Overview

- State sorted in a Storage Account
  - Previously created and part of it's own RG
  - Credentials from the Storage account and a Service Principal (with secret)

- Use modules to create:
  1. A RG
  2. Network
  3. NSG
  4. Public IP
  5. Load Balancer
  5. Linux VM (Standard_B1s)


## Notes

| Metric |	Exportable via diag | 	Metric |	Unit | Aggregation Type	| Description | 	Dimensions |
| ------ |	------ | 	------ |	------ | -------------	| ------ | 	------ |
| DipAvailability	| Yes	| Health Probe Status	| Count | 	Average	| Average Load Balancer health probe status per time duration | 	ProtocolType, BackendPort, FrontendIPAddress, FrontendPort, BackendIPAddress |

[Metrics Supported](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-supported)


DipAvailability	Yes	Health Probe Status	Count	Average	Average Load Balancer health probe status per time duration	ProtocolType, BackendPort, FrontendIPAddress, FrontendPort, BackendIPAddress


## Issues

- Tightly couple the Public IP with the LB, since the IP will only be used for the LB front end.  Previously this was decoupled, but 
it caused issues with passing varialbes for the public IP address id.  This was resolved and was probalby due to a bug in the code
but it should be tightly coupled with the LB along with the Backend Pool, Health Probe, and IN/Out Rules.




rgran@HPPAVILION-1 MINGW64 ~/Dropbox/IaC/MyIACWorkingCode/BluePrints/azure/lb-monitor/dev (main)
$ tfpl
╷
│ Error: expected criteria.0.aggregation to be one of [Average Count Minimum Maximum Total], got average
│
│   with module.loadbalancer.azurerm_monitor_metric_alert.example,
│   on ..\modules\loadbalancer\lb.tf line 87, in resource "azurerm_monitor_metric_alert" "example":
│   87:     aggregation      = "average"
│
╵



## TODO



## Revision History

| VER  | PROJECT     | DETAILS                                                     |
| -----|------------ |------------------------------------------------------------ |
| v0.0 | lb-monitor  | Start                                                       |
| v0.1 | lb-monitor  | Added modules: network, nsg, and connected the nsg to a subnet. |
| v0.2 | lb-monitor  | Coupled PIP in the LB module since there will be only one PIP and it will be attached to the LB FE.|


## Architecture

# Notes 

- Best practice?  Create resources in modules, but link them together in the main procedure.  This makes the main funcation as the business layer and the modules as services. 

## Repos
```
git clone 
```
# Procedure


