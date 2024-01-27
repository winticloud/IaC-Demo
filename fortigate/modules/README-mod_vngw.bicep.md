# mod_vngw.bicep

## Resources

| Symbolic Name | Type | Description |
| --- | --- | --- |
| resLngwConnection | [Microsoft.Network/connections](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/connections) |  |
| resLocalNetworkGateway | [Microsoft.Network/localNetworkGateways](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/localnetworkgateways) |  |
| resVpnGwIPs | [Microsoft.Network/publicIPAddresses](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/publicipaddresses) |  |
| resVpnNetworkGateway | [Microsoft.Network/virtualNetworkGateways](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/virtualnetworkgateways) |  |

## Parameters

| Name | Type | Description | Default |
| --- | --- | --- | --- |
| parAuthKey | string |  | uniqueString(newGuid(), utcNow()) |
| parBaseTagSet | object |  |  |
| parBgpAsnLgw | int |  |  |
| parBgpAsnPgw | int |  |  |
| parBgpPeeringAddress | string |  |  |
| parCustomerPublicIP | string |  |  |
| parHubVnet | string |  |  |
| parLocalGatewayName | string |  |  |
| parLocation | string |  |  |
| parP2sVpnSubnetPrefix | string |  |  |
| parVngwName | string |  |  |

## Variables

| Name | Description |
| --- | --- |
| varAadAudience | |
| varAadIssuer | |
| varAadTenant | |
