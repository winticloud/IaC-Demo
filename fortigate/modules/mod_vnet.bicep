param parBaseTagSet object
param parVnetName string
param parNetPrefix string
param parSubnets array

var varLocation = resourceGroup().location


resource resNsgs 'Microsoft.Network/networkSecurityGroups@2023-02-01' = [for loopSubnet in parSubnets: if ((loopSubnet.Name != 'GatewaySubnet')  && (loopSubnet.Name != 'FirewallPublicSubnet') && (loopSubnet.Name != 'FirewallPrivateSubnet')) {
  name: '${parVnetName}-nsg-${loopSubnet.name}'
  location: varLocation
  tags: union(parBaseTagSet, {
      Description: 'NSG ${parVnetName}-nsg-${loopSubnet.name}'
    })
}]

resource resVirtualNetwork 'Microsoft.Network/virtualNetworks@2022-11-01' = {
name: parVnetName
  location: varLocation
  tags: union(parBaseTagSet, {
      Description: 'Virtual Network ${parVnetName}'
    })
  properties: {
    addressSpace: {
      addressPrefixes: [
        parNetPrefix
      ]
    }
    subnets: [for (loopSubnet, i) in parSubnets: {
      name: '${loopSubnet.name}'
      properties: {
        addressPrefix: loopSubnet.ipAddressRange
        delegations: contains(loopSubnet, 'delegations') ? loopSubnet.delegations : null
        privateEndpointNetworkPolicies: contains(loopSubnet, 'privateEndpointNetworkPolicies') ? loopSubnet.privateEndpointNetworkPolicies : null
        privateLinkServiceNetworkPolicies: contains(loopSubnet, 'privateLinkServiceNetworkPolicies') ? loopSubnet.privateLinkServiceNetworkPolicies : null
        serviceEndpoints: contains(loopSubnet, 'serviceEndpoints') ? loopSubnet.serviceEndpoints : null
        networkSecurityGroup: loopSubnet.name != 'GatewaySubnet' && loopSubnet.name != 'AzureBastionSubnet' && loopSubnet.name != 'FirewallPublicSubnet' && loopSubnet.name != 'FirewallPrivateSubnet'  ? {
          id: resNsgs[i].id
        } : null
      }
    }]
  }
}

output outVnetIdentity string = resVirtualNetwork.id
output outVnetName string = resVirtualNetwork.name
