# mod_keyvault.bicep

## Resources

| Symbolic Name | Type | Description |
| --- | --- | --- |
| resKeyVaultName | [Microsoft.KeyVault/vaults](https://learn.microsoft.com/en-us/azure/templates/microsoft.keyvault/vaults) |  |
| resKeyVaultName_VPNGatewayPSK | [Microsoft.KeyVault/vaults/secrets](https://learn.microsoft.com/en-us/azure/templates/microsoft.keyvault/vaults/secrets) |  |
| resKeyVaultName_virtualMachineLocalAdminPassword | [Microsoft.KeyVault/vaults/secrets](https://learn.microsoft.com/en-us/azure/templates/microsoft.keyvault/vaults/secrets) |  |

## Parameters

| Name | Type | Description | Default |
| --- | --- | --- | --- |
| parAdminUserObjectID | string | Object ID of admin user in Azure AD. This User will get access rights to KeyVault | ab82d40f-8459-46bb-8939-fb096442d43d |
| parBaseTagSet | object |  |  |
| parKeyVaultName | string | Name of the key vault | phun-kv1-csn |
| parLocation | string |  | [resourceGroup().location] |
| parPublicIPToWhitelist | array | Whitelist Public IP for KeyVault Configuration |  |
| parVirtualMachineLocalAdminPassword | securestring | Localadmin Password of an Azure VM | IM KEEPASS |
| parVpnGatewayPSK | string | VPNGateway Pre-Shared-Key (PSK) of an Azure Gateway | IM KEEPASS |

## Variables

| Name | Description |
| --- | --- |
| varTenantId | |
