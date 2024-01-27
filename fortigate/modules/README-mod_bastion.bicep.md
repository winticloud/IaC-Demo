# mod_bastion.bicep

## Resources

| Symbolic Name | Type | Description |
| --- | --- | --- |
| resBastionHost | [Microsoft.Network/bastionHosts](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/bastionhosts) |  |
| resBastionNsg | [Microsoft.Network/networkSecurityGroups](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/networksecuritygroups) |  |
| resBastionPublicIP | [Microsoft.Network/publicIPAddresses](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/publicipaddresses) |  |

## Parameters

| Name | Type | Description | Default |
| --- | --- | --- | --- |
| parBaseTagSet | object |  |  |
| parBastionHostName | string |  |  |
| parHubVnet | string |  |  |
| parHubVnetRg | string |  |  |
| parLocation | string |  |  |
