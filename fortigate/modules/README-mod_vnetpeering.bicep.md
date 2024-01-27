# mod_vnetpeering.bicep

## Resources

| Symbolic Name | Type | Description |
| --- | --- | --- |
| resPeerVirtualNetworks | [Microsoft.Network/virtualNetworks/virtualNetworkPeerings](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/virtualnetworks/virtualnetworkpeerings) |  |
| resVnet | [Microsoft.Network/virtualNetworks](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/virtualnetworks) |  |

## Parameters

| Name | Type | Description | Default |
| --- | --- | --- | --- |
| allowGwTransit | bool |  |  |
| useRemoteGw | bool |  |  |
| vnetName | string |  |  |
| vnetRemoteName | string |  |  |
| vnetToPeer | string |  |  |
