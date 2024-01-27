# mod_connectivity.bicep

## Modules

| Symbolic Name | Source | Description |
| --- | --- | --- |
| modBastion | mod_bastion.bicep |  |
| modPrivateDNSHub | mod_pdns.bicep |  |
| modPrivateDNSSpoke | mod_pdns.bicep |  |
| modVirtualNetworks | ./mod_vnet.bicep |  |
| modVngw | ./mod_vngw.bicep |  |

## Resources

| Symbolic Name | Type | Description |
| --- | --- | --- |
| resPrivateDnsRg | [Microsoft.Resources/resourceGroups](https://learn.microsoft.com/en-us/azure/templates/microsoft.resources/resourcegroups) |  |
| resVirtualNetworkRg | [Microsoft.Resources/resourceGroups](https://learn.microsoft.com/en-us/azure/templates/microsoft.resources/resourcegroups) |  |

## Parameters

| Name | Type | Description | Default |
| --- | --- | --- | --- |
| parBaseTagSet | object |  |  |
| parBastionHostName | string |  |  |
| parBgpAsnLgw | int |  |  |
| parBgpAsnPgw | int |  |  |
| parBgpPeeringAddress | string |  |  |
| parCustomerPublicIP | string |  |  |
| parDeployBastion | bool |  |  |
| parDeployPrivateDns | bool |  |  |
| parLocation | string |  |  |
| parP2sPrefix | string |  |  |
| parPrivateDnsRg | string |  |  |
| parPrivateDnsZones | array |  |  |
| parVirtualNetworks | array |  |  |
| parVnetName | string |  |  |
| parVngwName | string |  |  |
