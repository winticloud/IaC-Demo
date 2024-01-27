targetScope= 'subscription'

param parLocation string
param parVirtualNetworks array
param parVngwName string
param parVnetName string
param parBgpAsnPgw int
param parBgpAsnLgw int
param parBgpPeeringAddress string
param parDeployBastion bool
param parDeployPrivateDns bool
param parBastionHostName string
param parP2sPrefix string
param parCustomerPublicIP string
param parPrivateDnsRg string
param parPrivateDnsZones array
param parBaseTagSet object


resource resVirtualNetworkRg 'Microsoft.Resources/resourceGroups@2022-09-01' = [for loopNet in parVirtualNetworks : {
  name: loopNet.resourceGroup
  location: parLocation
  tags: parBaseTagSet
}]

resource resPrivateDnsRg 'Microsoft.Resources/resourceGroups@2022-09-01' = if (parDeployPrivateDns) {
  name: parPrivateDnsRg
  location: parLocation
  tags: parBaseTagSet
}

module modVirtualNetworks 'mod_vnet.bicep' = [for loopNet in parVirtualNetworks: {
  name: 'deploy-${loopNet.vnetName}'
  scope: resourceGroup(loopNet.resourceGroup)
  params: { 
  parVnetName: loopNet.vnetName
  parNetPrefix: loopNet.netPrefix
  parSubnets: loopNet.subnets
  parBaseTagSet: parBaseTagSet
  }
  dependsOn: [
    resVirtualNetworkRg
  ]
}]

module modVngw 'mod_vngw.bicep' = {
  name: 'deploy-vpn-gateway'
  scope: resVirtualNetworkRg[0]
  params:{
    parLocation: parLocation
    parVngwName: parVngwName
    parLocalGatewayName: '${parVngwName}-lngw1'
    parBgpAsnPgw: parBgpAsnPgw
    parBgpAsnLgw: parBgpAsnLgw
    parBgpPeeringAddress: parBgpPeeringAddress
    parP2sVpnSubnetPrefix: parP2sPrefix
    parHubVnet: modVirtualNetworks[0].outputs.outVnetName
    parCustomerPublicIP: parCustomerPublicIP
    parBaseTagSet: parBaseTagSet
  }
  dependsOn: [
    modVirtualNetworks
  ]
}

module modBastion 'mod_bastion.bicep' = if (parDeployBastion) {
  name: 'deploy-modBastion-host'
  scope: resVirtualNetworkRg[0]
  params: {
    parLocation: parLocation
    parBastionHostName: parBastionHostName
    parHubVnet: modVirtualNetworks[0].outputs.outVnetName
    parHubVnetRg:parVirtualNetworks[0].resourceGroup
    parBaseTagSet: parBaseTagSet
  }
  dependsOn: [
    modVirtualNetworks
  ]
}

/* module modPeerVnetHubtoSpoke 'mod_vnetpeering.bicep' = {
  name: 'deploy-vnetpeering-hub'
  scope: resVirtualNetworkRg[1]
  params:{
    vnetName: modVirtualNetworks[1].outputs.outVnetName
    vnetToPeer: modVirtualNetworks[0].outputs.outVnetIdentity
    vnetRemoteName: modVirtualNetworks[0].outputs.outVnetName
    useRemoteGw: true
    allowGwTransit: false
  }
  dependsOn: [
    modVngw
  ]
} */
/* 
module modPeerVnetSpoketoHub 'mod_vnetpeering.bicep' = {
  name: 'deploy-vnetpeering-spoke'
  scope: resVirtualNetworkRg[0]
  params:{
    vnetName: modVirtualNetworks[0].outputs.outVnetName
    vnetToPeer: modVirtualNetworks[1].outputs.outVnetIdentity
    vnetRemoteName: modVirtualNetworks[1].outputs.outVnetName
    useRemoteGw: false
    allowGwTransit: true
  }
  dependsOn: [
    modVngw
  ]
} */

module modPrivateDNSHub 'mod_pdns.bicep' = [for (zone, i) in parPrivateDnsZones: if (parDeployPrivateDns) {
  name: 'deploy-DNSZones-${uniqueString('zonesHub')}${i}'
  scope: resPrivateDnsRg
  params:{
    parPrivateDnsZone: zone
    parLinkName: 'linkToHub'
    parVnetLinkId: modVirtualNetworks[0].outputs.outVnetIdentity
    parBaseTagSet: parBaseTagSet
  }
  dependsOn: [
    modVirtualNetworks
  ]
}]

module modPrivateDNSSpoke 'mod_pdns.bicep' = [for (zone, i) in parPrivateDnsZones: if (parDeployPrivateDns) {
  name: 'deploy-DNSZones-${uniqueString('zonesSpoke')}${i}'
  scope: resPrivateDnsRg
  params:{
    parPrivateDnsZone: zone
    parLinkName: 'linkToSpoke'
    parVnetLinkId: modVirtualNetworks[1].outputs.outVnetIdentity
    parBaseTagSet: parBaseTagSet
  }
  dependsOn: [
    modVirtualNetworks
    modPrivateDNSHub
  ]
}]
