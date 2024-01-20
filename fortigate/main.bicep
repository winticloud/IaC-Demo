targetScope = 'subscription'

//unused, due to supported functions in bicepparam
param parVnetHubPrefix string
param parVnetSpoke1Prefix string

//deployment switches
param parDeployVnet bool
param parDeployBastion bool
param parDeployPrivateDns bool

param parSubscriptionId string
param parLocation string
param parLocationPostfix string
param parEnvironment string
param parCustomerPrefix string

param parAdminUsername string

@secure()
param parAdminPassword string


output outAdminPasswordOutput string = parAdminPassword
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

resource resVnetRgExists 'Microsoft.Resources/resourceGroups@2022-09-01' existing = if (!parDeployVnet){
  name: parHubVnetName
  location: parLocation
}

resource resVnetExists 'Microsoft.Network/virtualNetworks@2023-04-01' existing = if (!parDeployVnet) {
  scope: resVnetRgExists
  name: parHubVnetName
}

resource resVnetRg 'Microsoft.Resources/resourceGroups@2022-09-01' = if (parDeployVnet) {
  name: parHubVnetRg
  location: parLocation
}

resource resFortiRg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: varFortiRgName
  location: parLocation
}

resource resKeyvaultRg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: parKeyVaultRg
  location: parLocation
}

module modKeyvault 'modules/mod_keyvault.bicep' = {
  name: 'deploy-keyvault'
  scope: resKeyvaultRg
  params: {
    parLocation: parLocation
    parKeyVaultName: parEnvironment
    parAdminUserObjectID: parCustomerPrefix
    parVirtualMachineLocalAdminPassword: parAdminPassword
    parVpnGatewayPSK: parVpnGatewayPSK
    parPublicIPToWhitelist: parPublicIPToWhitelist
    parBaseTagSet: parBaseTagSet
  }
}

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
    parAdminPassword: parAdminPassword
    parPublicSubnetId: varPublicSubnetId
    parPrivateSubnetId: varPrivateSubnetId
    parBaseTagSet: parBaseTagSet
  }
  dependsOn:[
    modConnectivity
  ]
}
