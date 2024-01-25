# main.bicep

## Modules

| Symbolic Name | Source | Description |
| --- | --- | --- |
| modConnectivity | modules/mod_connectivity.bicep |  |
| modFortiNVA | modules/mod_fnva.bicep |  |
| modKeyvault | modules/mod_keyvault.bicep |  |

## Resources

| Symbolic Name | Type | Description |
| --- | --- | --- |
| resFortiRg | [Microsoft.Resources/resourceGroups](https://learn.microsoft.com/en-us/azure/templates/microsoft.resources/resourcegroups) |  |
| resKeyvaultRg | [Microsoft.Resources/resourceGroups](https://learn.microsoft.com/en-us/azure/templates/microsoft.resources/resourcegroups) |  |
| resVnetExists | [Microsoft.Network/virtualNetworks](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/virtualnetworks) |  |
| resVnetRg | [Microsoft.Resources/resourceGroups](https://learn.microsoft.com/en-us/azure/templates/microsoft.resources/resourcegroups) |  |
| resVnetRgExists | [Microsoft.Resources/resourceGroups](https://learn.microsoft.com/en-us/azure/templates/microsoft.resources/resourcegroups) |  |

## Parameters

| Name | Type | Description | Default |
| --- | --- | --- | --- |
| parAdminPassword | securestring |  |  |
| parAdminUserObjectID | string |  |  |
| parAdminUsername | string |  |  |
| parBaseTagSet | object |  |  |
| parBgpAsnLgw | int |  |  |
| parBgpAsnPgw | int |  |  |
| parBgpPeeringAddress | string |  |  |
| parCustomerPrefix | string |  |  |
| parCustomerPublicIp | string |  |  |
| parDeployBastion | bool | Specifies whether to deploy Bastion Host |  |
| parDeployPrivateDns | bool | Specifies whether to deploy Private DNS Zones |  |
| parDeployVnet | bool | Specifies whether to deploy a vnet |  |
| parEnvironment | string |  |  |
| parFortiImageSku | string |  |  |
| parFortiImageVersion | string |  |  |
| parFortiInstance | string |  |  |
| parFortiPrivateIp | string |  |  |
| parHubVnetName | string |  |  |
| parHubVnetRg | string |  |  |
| parKeyVaultName | string |  |  |
| parKeyVaultRg | string |  |  |
| parLocation | string |  |  |
| parLocationPostfix | string |  |  |
| parP2sPrefix | string |  |  |
| parPrivateDnsZones | array |  |  |
| parPublicIPToWhitelist | array |  |  |
| parSubscriptionId | string |  |  |
| parVirtualNetworks | array |  |  |
| parVnetHubPrefix | string |  |  |
| parVnetSpoke1Prefix | string |  |  |
| parVpnGatewayPSK | string |  |  |

