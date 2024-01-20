param parBaseTagSet object
param parVnetName string
param parNetPrefix string
param parSubnets array

var varLocation = resourceGroup().location


resource resNsgs 'Microsoft.Network/networkSecurityGroups@2023-02-01' = [for snet in parSubnets: if((snet.Name != 'GatewaySubnet') && (snet.Name != 'AzureBastionSubnet')) {
  name: '${parVnetName}-nsg-${snet.name}'
  location: varLocation
}]

resource resVirtualNetwork 'Microsoft.Network/virtualNetworks@2022-11-01' = {
name: parVnetName
  location: varLocation
  tags: parBaseTagSet
  properties: {
    addressSpace: {
      addressPrefixes: [
        parNetPrefix
      ]
    }
    subnets: [for (subnet, i) in parSubnets: {
      name: '${subnet.name}'
      properties: {
        addressPrefix: subnet.ipAddressRange
        delegations: contains(subnet, 'delegations') ? subnet.delegations : null
        privateEndpointNetworkPolicies: contains(subnet, 'privateEndpointNetworkPolicies') ? subnet.privateEndpointNetworkPolicies : null
        privateLinkServiceNetworkPolicies: contains(subnet, 'privateLinkServiceNetworkPolicies') ? subnet.privateLinkServiceNetworkPolicies : null
        serviceEndpoints: contains(subnet, 'serviceEndpoints') ? subnet.serviceEndpoints : null
        networkSecurityGroup: subnet.name != 'GatewaySubnet' && subnet.name != 'AzureBastionSubnet' ? {
          id: resNsgs[i].id
        } : null
      }
    }]
  }
}

output outVnetIdentity string = resVirtualNetwork.id
output outVnetName string = resVirtualNetwork.name
