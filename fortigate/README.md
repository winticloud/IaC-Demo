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
| storageAccountName | string | Storage account name restrictions:
<br>- Storage account names must be between 3 and 24 characters in length and may contain numbers and lowercase letters only.
<br>- Your storage account name must be unique within Azure. No two storage accounts can have the same name.
<br> |  |

## User Defined Data Types (UDDTs)

| Name | Type | Description |
| --- | --- | --- |
| myStringType | string | data type |

## Variables

| Name | Description |
| --- | --- |
| varFortiName | |
| varFortiRgName | |
| varPrivateSubnetId | |
| varPublicSubnetId | |
| varRouteTableName | |

## Outputs

| Name | Type | Description |
| --- | --- | --- |
| outFortiRgName | string | output fortigate name |
