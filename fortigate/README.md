# main.bicep

## Modules

| Symbolic Name | Source | Description |
| --- | --- | --- |
| modConnectivity | modules/mod_connectivity.bicep | module to deploy conntectivity (vnet, private DNS, VPN GW, bastion host) |
| modFortiNVA | modules/mod_fnva.bicep | module to deploy fortigate NVA (NICs, public IP, VM, NSG) |
| modKeyvault | modules/mod_keyvault.bicep | module to deploy keyvault |

## Resources

| Symbolic Name | Type | Description |
| --- | --- | --- |
| resFortiRg | [Microsoft.Resources/resourceGroups](https://learn.microsoft.com/en-us/azure/templates/microsoft.resources/resourcegroups) | new fortigate resource group |
| resKeyvaultRg | [Microsoft.Resources/resourceGroups](https://learn.microsoft.com/en-us/azure/templates/microsoft.resources/resourcegroups) | new keyvault resource group |
| resVnetExists | [Microsoft.Network/virtualNetworks](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/virtualnetworks) | existing hub vnet resource |
| resVnetRg | [Microsoft.Resources/resourceGroups](https://learn.microsoft.com/en-us/azure/templates/microsoft.resources/resourcegroups) | new hub vnet resource group |
| resVnetRgExists | [Microsoft.Resources/resourceGroups](https://learn.microsoft.com/en-us/azure/templates/microsoft.resources/resourcegroups) | existing hub vnet resource group |

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
| parDeployBastion | bool | Specifies whether to deploy Bastion Host | false |
| parDeployPrivateDns | bool | Specifies whether to deploy Private DNS Zones | false |
| parDeployVnet | bool | Specifies whether to deploy a vnet | false |
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
| storageAccountName | string | Storage account name restrictions:
- Storage account names must be between 3 and 24 characters in length and may contain numbers and lowercase letters only.
- Your storage account name must be unique within Azure. No two storage accounts can have the same name.
 |  |

## User Defined Data Types (UDDTs)

| Name | Type | Description |
| --- | --- | --- |
| myStringType | string | data type |

## Variables

| Name |
| --- |
| varFortiName |
| varFortiRgName |
| varPrivateSubnetId |
| varPublicSubnetId |
| varRouteTableName |

## Outputs

| Name | Type | Description |
| --- | --- | --- |
| outFortiRgName | string | output fortigate name |
