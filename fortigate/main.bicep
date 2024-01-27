targetScope = 'subscription'

//unused, due to supported functions in bicepparam
param parVnetHubPrefix string
param parVnetSpoke1Prefix string

//deployment switches
@description('Specifies whether to deploy a vnet')
param parDeployVnet bool = false
@description('Specifies whether to deploy Bastion Host')
param parDeployBastion bool = false
@description('Specifies whether to deploy Private DNS Zones')
param parDeployPrivateDns bool = false

param parSubscriptionId string
param parLocation string
param parLocationPostfix string
param parEnvironment string
param parCustomerPrefix string

param parAdminUsername string
@secure()
param parAdminPasswordSecret string
@secure()
param parKeyVaultSecretsName string

// @secure()
// param parAdminPassword string

@description('''
Storage account name restrictions:
- Storage account names must be between 3 and 24 characters in length and may contain numbers and lowercase letters only.
- Your storage account name must be unique within Azure. No two storage accounts can have the same name.
''')
@minLength(3)
@maxLength(24)
param storageAccountName string

//network parameters
param parHubVnetName string
param parHubVnetRg string
param parBgpAsnPgw int
param parBgpAsnLgw int
param parBgpPeeringAddress string
param parP2sPrefix string
param parCustomerPublicIp string
param parVirtualNetworks array
param parPrivateDnsZones array

//Fortigate parameters
@allowed([
  '7.0.12'
])
param parFortiImageVersion string

@allowed([
  'fortinet_fg-vm'
  'fortinet_fg-vm_payg'
])
param parFortiImageSku string

@allowed([
  'Standard_DS3_v2'
  'Standard_DS4_v2'
  'Standard_DS5_v2'
])

param parFortiInstance string
param parFortiPrivateIp string
param parBaseTagSet object

// Keyvault Parameters
param parKeyVaultName string 
param parKeyVaultRg string
param parAdminUserObjectID string
param parVpnGatewayPSK string
param parPublicIPToWhitelist array


// build naming convention based resource names
var varFortiRgName = '${parEnvironment}${parCustomerPrefix}-fw1-${parLocationPostfix}-rg'
var varFortiName = '${parEnvironment}${parCustomerPrefix}-fw1-${parLocationPostfix}'
var varRouteTableName = ''

var varPublicSubnetId = resourceId(subscription().subscriptionId,parHubVnetRg,'Microsoft.Network/VirtualNetworks/Subnets',parHubVnetName,'FirewallPublicSubnet')
var varPrivateSubnetId = resourceId(subscription().subscriptionId,parHubVnetRg,'Microsoft.Network/VirtualNetworks/Subnets',parHubVnetName,'FirewallPrivateSubnet')

@description('existing hub vnet resource group')
resource resVnetRgExists 'Microsoft.Resources/resourceGroups@2022-09-01' existing = if (!parDeployVnet){
  name: parHubVnetName
  location: parLocation
}

@description('existing hub vnet resource')
resource resVnetExists 'Microsoft.Network/virtualNetworks@2023-04-01' existing = if (!parDeployVnet) {
  scope: resVnetRgExists
  name: parHubVnetName
}

@description('new hub vnet resource group')
resource resVnetRg 'Microsoft.Resources/resourceGroups@2022-09-01' = if (parDeployVnet) {
  name: parHubVnetRg
  location: parLocation
}

@description('new fortigate resource group')
resource resFortiRg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: varFortiRgName
  location: parLocation
}

@description('new keyvault resource group')
resource resKeyvaultRg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: parKeyVaultRg
  location: parLocation
}

// @description('module to deploy keyvault')
// module modKeyvault 'modules/mod_keyvault.bicep' = {
//   name: 'deploy-keyvault'
//   scope: resKeyvaultRg
//   params: {
//     parLocation: parLocation
//     parKeyVaultName: parEnvironment
//     parAdminUserObjectID: parCustomerPrefix
//     parVirtualMachineLocalAdminPassword: parAdminPassword
//     parVpnGatewayPSK: parVpnGatewayPSK
//     parPublicIPToWhitelist: parPublicIPToWhitelist
//     parBaseTagSet: parBaseTagSet
//   }
// }

@description('the keyvault and secret was created beforehand with the powershell script')
resource resKeyVault 'Microsoft.KeyVault/vaults@2019-09-01'  existing  = { 
  name: 'name'
  scope: resKeyvaultRg
}


@description('module to deploy conntectivity (vnet, private DNS, VPN GW, bastion host)')
module modConnectivity 'modules/mod_connectivity.bicep' = if (parDeployVnet) {
  name: 'deploy-connectivity'
  scope: subscription(parSubscriptionId)
  params:{
    parLocation: parLocation
    parVirtualNetworks: parVirtualNetworks
    parVngwName: '${parEnvironment}${parCustomerPrefix}-vngw1-${parLocationPostfix}'
    parVnetName: parHubVnetName
    parBgpAsnPgw: parBgpAsnPgw
    parBgpAsnLgw: parBgpAsnLgw
    parBgpPeeringAddress: parBgpPeeringAddress 
    parDeployBastion: parDeployBastion
    parDeployPrivateDns: parDeployPrivateDns
    parBastionHostName: '${parEnvironment}${parCustomerPrefix}-bast1-${parLocationPostfix}'
    parP2sPrefix: parP2sPrefix
    parCustomerPublicIP: parCustomerPublicIp
    parPrivateDnsRg: '${parEnvironment}${parCustomerPrefix}-privdns1-${parLocationPostfix}-rg'
    parPrivateDnsZones: parPrivateDnsZones
    parBaseTagSet: parBaseTagSet
  }
}

@description('module to deploy fortigate NVA (NICs, public IP, VM, NSG)')
module modFortiNVA 'modules/mod_fnva.bicep' = {
  name: 'deploy-fortigate-nva'
  scope: resFortiRg
  params: {
    parLocation: parLocation
    parFortiName: varFortiName
    parFortiInstance: parFortiInstance
    parFortiImageVersion: parFortiImageVersion
    parFortiImageSku: parFortiImageSku
    parFortiPrivateNicIp:  '${substring(parVnetHubPrefix,0,6)}.3.4'
    parFortiPublicNicIp:  '${substring(parVnetHubPrefix,0,6)}.2.4'
    parAdminUsername: parAdminUsername
    // parAdminPassword: parAdminPassword
    parAdminPassword: parAdminPasswordSecret
    parPublicSubnetId: varPublicSubnetId
    parPrivateSubnetId: varPrivateSubnetId
    parBaseTagSet: parBaseTagSet
  }
  dependsOn:[
    modConnectivity
  ]
}

@description('data type')
type myStringType = string  

@description('output fortigate name')
output outFortiRgName string = resFortiRg.name
