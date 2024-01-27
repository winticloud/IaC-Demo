# mod_vnet.bicep

## Resources

| Symbolic Name | Type | Description |
| --- | --- | --- |
| resNsgs | [Microsoft.Network/networkSecurityGroups](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/networksecuritygroups) |  |
| resVirtualNetwork | [Microsoft.Network/virtualNetworks](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/virtualnetworks) |  |

## Parameters

| Name | Type | Description | Default |
| --- | --- | --- | --- |
| parBaseTagSet | object |  |  |
| parNetPrefix | string |  |  |
| parSubnets | array |  |  |
| parVnetName | string |  |  |

## Variables

| Name | Description |
| --- | --- |
| varLocation | |

## Outputs

| Name | Type | Description |
| --- | --- | --- |
| outVnetIdentity | string |  |
| outVnetName | string |  |
