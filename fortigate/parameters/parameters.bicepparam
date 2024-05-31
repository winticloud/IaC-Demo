using '../main.bicep'

// conditional deployment
@description('Specifies whether to deploy a vnet')
param parDeployVnet = true

/// Specifies whether to deploy a bastion host.
@description('Specifies whether to deploy a bastion host')
param parDeployBastion = false

/// Specifies whether to deploy private DNS.
@description('Specifies whether to deploy private DNS')
param parDeployPrivateDns = false

/// Specifies whether to deploy VPN Gateway.
@description('Specifies whether to deploy a VPN Gateway')
param parDeployVpnGw = false

param parSubscriptionId = '3e93b848-f45a-4efa-ae91-e508f932bfda'
param parLocation = 'switzerlandnorth'
@maxLength(3)
param parLocationPostfix = 'csn'
@maxLength(1)
param parEnvironment = 't'
@maxLength(3)
param parCustomerPrefix = 'wcl'

param storageAccountName = '${parEnvironment}${parCustomerPrefix}sa1${parLocationPostfix}'

param parKeyVaultName = '${parEnvironment}${parCustomerPrefix}-kv1-${parLocationPostfix}' 
param parKeyVaultRg = '${parEnvironment}${parCustomerPrefix}-kv1-${parLocationPostfix}-rg' 
param parKeyVaultSecretsName = 'FortigateAdminPassword'

param parAdminUsername = 'localadmin'
// param parAdminPasswordSecret = getSecret(parSubscriptionId, parKeyVaultRg, parKeyVaultName, parKeyVaultSecretsName)
param parAdminPasswordSecret = 'P@ssw0rd1234'

param parAdminUserObjectID = '' 
param parVpnGatewayPSK = '' 
param parPublicIPToWhitelist = [] 

param parPrivateDnsZones = [
  'privatelink.azure-automation.net'
  'privatelink.azurewebsites.net'
  'privatelink.blob.core.windows.net'
  'privatelink.database.windows.net'
  'privatelink.datafactory.azure.net'
  'privatelink.file.core.windows.net'
  'privatelink.monitor.azure.com'
  'privatelink.vaultcore.azure.net'
]

/* param parBaseTagSet = {
  Creator: 'hugh.jass@yourdomain.com'
  CreationDate: '31.05.2025'
} */

// Tag Parameter
param parBaseTagSet  = {
  Creator: 'XXX@baggenstos.ch'
  CreationDate: ''
  Environment: 'Prod'
  CostBranch: 'connectivity'
}


// set the Creator value of param parBaseTag to a new value using join

param parFortiImageVersion = '7.2.8'
// Identifies whether to to use PAYG (on demand licensing) or BYOL license model (where license is purchased separately)
param parFortiImageSku = 'fortinet_fg-vm'
param parFortiInstance = 'Standard_D2s_v5'
param parFortiPrivateIp = '10.10.10.10'
@description('IP Range for P2S VPN')
param parP2sPrefix = '10.110.0.0/24'
param parCustomerPublicIp = '1.1.1.1'

param parVnetHubPrefix = '10.100.0.0/16'
param parVnetSpoke1Prefix = '10.101.0.0/16'
param parBgpAsnPgw = 65400
param parBgpAsnLgw = 65405
param parBgpPeeringAddress = '169.254.0.1'

// existing vnet
param parHubVnetName = '${parEnvironment}${parCustomerPrefix}-vnet1-${parLocationPostfix}'
param parHubVnetRg = '${parEnvironment}${parCustomerPrefix}-vnet1-${parLocationPostfix}-rg'

// without vnet
// GatewaySubnet needs to be  first subnet for logic to work
// 
param parVirtualNetworks = [
  {
    vnetName: '${parEnvironment}${parCustomerPrefix}-vnet1-${parLocationPostfix}'
    resourceGroup: '${parEnvironment}${parCustomerPrefix}-vnet1-${parLocationPostfix}-rg'
    netPrefix: parVnetHubPrefix
    subnets:[
    {
      name: 'GatewaySubnet'
      ipAddressRange: '${substring(parVnetHubPrefix,0,6)}.0.0/24'
      networkSecurityGroupId: ''
      routeTableId: ''
    }
    {
      name: 'AzureBastionSubnet'
      ipAddressRange: '${substring(parVnetHubPrefix,0,6)}.1.0/24'
      networkSecurityGroupId: ''
      routeTableId: ''
    }
    {
      name: 'FirewallPublicSubnet'
      ipAddressRange: '${substring(parVnetHubPrefix,0,6)}.2.0/24'
      networkSecurityGroupId: ''
      routeTableId: ''
    }
    {
      name: 'FirewallPrivateSubnet'
      ipAddressRange: '${substring(parVnetHubPrefix,0,6)}.3.0/24'
      networkSecurityGroupId: ''
      routeTableId: ''
    }
    {
      name: 'FirewallManagementSubnet'
      ipAddressRange: '${substring(parVnetHubPrefix,0,6)}.4.0/24'
      networkSecurityGroupId: ''
      routeTableId: ''
    }
    {
      name: 'FirewallHaSyncSubnet'
      ipAddressRange: '${substring(parVnetHubPrefix,0,6)}.5.0/24'
      networkSecurityGroupId: ''
      routeTableId: ''
    }
    {
      name: 'ApplicationGwWAFSubnet'
      ipAddressRange: '${substring(parVnetHubPrefix,0,6)}.6.0/24'
      networkSecurityGroupId: ''
      routeTableId: ''
    }
    {
      name: 'SharedServicesSubnet'
      ipAddressRange: '${substring(parVnetHubPrefix,0,6)}.7.0/24'
      networkSecurityGroupId: ''
      routeTableId: ''
    }
  ]
  }
  {
    vnetName: '${parEnvironment}${parCustomerPrefix}-vnet2-${parLocationPostfix}'
    resourceGroup: '${parEnvironment}${parCustomerPrefix}-vnet2-${parLocationPostfix}-rg'
    netPrefix: parVnetSpoke1Prefix
    subnets:[
    {
      name: 'PrivateEndpointSubnet'
      ipAddressRange: '${substring(parVnetSpoke1Prefix,0,6)}.0.0/24'
      networkSecurityGroupId: ''
      routeTableId: ''
    }
    {
      name: 'ADDSSubnet'
      ipAddressRange: '${substring(parVnetSpoke1Prefix,0,6)}.1.0/24'
      networkSecurityGroupId: ''
      routeTableId: ''
    }
    {
      name: 'ManagementSubnet'
      ipAddressRange: '${substring(parVnetSpoke1Prefix,0,6)}.2.0/24'
      networkSecurityGroupId: ''
      routeTableId: ''
    }
  ]
}
]

