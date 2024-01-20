@description('Name of the key vault')
param parKeyVaultName string = 'phun-kv1-csn'

@description('Object ID of admin user in Azure AD. This User will get access rights to KeyVault')
param parAdminUserObjectID string = 'ab82d40f-8459-46bb-8939-fb096442d43d'

@description('Localadmin Password of an Azure VM')
@secure()
param parVirtualMachineLocalAdminPassword string = 'IM KEEPASS'

@description('VPNGateway Pre-Shared-Key (PSK) of an Azure Gateway')
param parVpnGatewayPSK string = 'IM KEEPASS'

@description('Whitelist Public IP for KeyVault Configuration')
param parPublicIPToWhitelist array

param parBaseTagSet  object 

param parLocation string = resourceGroup().location

var varTenantId = subscription().tenantId

resource resKeyVaultName 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: parKeyVaultName
  location: parLocation
  tags: union(parBaseTagSet, {
    Description: 'KeyVault for VM passwords, VPN PSKs, Azure Resource Manager deployments and general use'
  })
  properties: {
    enablePurgeProtection: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
    publicNetworkAccess: 'Enabled'
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    enableRbacAuthorization: false
    tenantId: varTenantId
    accessPolicies: [
      {
        tenantId: varTenantId
        objectId: parAdminUserObjectID
        permissions: {
          keys: [
            'get'
            'list'
            'update'
            'create'
            'import'
            'delete'
            'recover'
            'backup'
            'restore'
            'decrypt'
            'encrypt'
            'unwrapKey'
            'wrapKey'
            'verify'
            'sign'
            'purge'
          ]
          secrets: [
            'get'
            'list'
            'set'
            'delete'
            'recover'
            'backup'
            'restore'
            'purge'
          ]
          certificates: [
            'get'
            'list'
            'update'
            'create'
            'import'
            'delete'
            'recover'
            'managecontacts'
            'manageissuers'
            'getissuers'
            'listissuers'
            'setissuers'
            'deleteissuers'
            'purge'
          ]
        }
      }
    ]
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
      ipRules: [for publicIP in parPublicIPToWhitelist: {
        value: publicIP
      }]
      virtualNetworkRules: []
    }
    sku: {
      name: 'standard'
      family: 'A'
    }
  }
}

resource resKeyVaultName_virtualMachineLocalAdminPassword 'Microsoft.KeyVault/vaults/secrets@2016-10-01' = {
  parent: resKeyVaultName
  name: 'parVirtualMachineLocalAdminPassword'
  properties: {
    value: parVirtualMachineLocalAdminPassword
  }
}

resource resKeyVaultName_VPNGatewayPSK 'Microsoft.KeyVault/vaults/secrets@2016-10-01' = {
  parent: resKeyVaultName
  name: 'parVpnGatewayPSK'
  properties: {
    value: parVpnGatewayPSK
  }
}
