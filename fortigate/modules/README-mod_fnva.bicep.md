# mod_fnva.bicep

## Resources

| Symbolic Name | Type | Description |
| --- | --- | --- |
| resFortiNsg | [Microsoft.Network/networkSecurityGroups](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/networksecuritygroups) |  |
| resFortiPrivateNic | [Microsoft.Network/networkInterfaces](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/networkinterfaces) |  |
| resFortiPublicNic | [Microsoft.Network/networkInterfaces](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/networkinterfaces) |  |
| resFortiVm | [Microsoft.Compute/virtualMachines](https://learn.microsoft.com/en-us/azure/templates/microsoft.compute/virtualmachines) |  |
| resPublicIp | [Microsoft.Network/publicIPAddresses](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/publicipaddresses) |  |

## Parameters

| Name | Type | Description | Default |
| --- | --- | --- | --- |
| parAdminPassword | securestring |  |  |
| parAdminUsername | string |  |  |
| parBaseTagSet | object |  |  |
| parFortiImageSku | string |  |  |
| parFortiImageVersion | string |  |  |
| parFortiInstance | string |  |  |
| parFortiName | string |  |  |
| parFortiPrivateNicIp | string |  |  |
| parFortiPublicNicIp | string |  |  |
| parLocation | string |  |  |
| parPrivateSubnetId | string |  |  |
| parPublicSubnetId | string |  |  |
