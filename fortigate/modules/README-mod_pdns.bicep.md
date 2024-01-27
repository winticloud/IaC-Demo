# mod_pdns.bicep

## Resources

| Symbolic Name | Type | Description |
| --- | --- | --- |
| resPrivateDnsZone | [Microsoft.Network/privateDnsZones](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/privatednszones) |  |
| resVnetLinkHub | [Microsoft.Network/privateDnsZones/virtualNetworkLinks](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/privatednszones/virtualnetworklinks) |  |

## Parameters

| Name | Type | Description | Default |
| --- | --- | --- | --- |
| parBaseTagSet | object |  |  |
| parLinkName | string |  |  |
| parPrivateDnsZone | string |  |  |
| parVnetLinkId | string |  |  |

## Variables

| Name | Description |
| --- | --- |
| varVirtualNetworkLinkName | |
