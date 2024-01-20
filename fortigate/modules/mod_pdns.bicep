param parPrivateDnsZone string
param parLinkName string
param parVnetLinkId string
param parBaseTagSet object

var varVirtualNetworkLinkName = '${parPrivateDnsZone}/${parLinkName}'

resource resPrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: parPrivateDnsZone
  location: 'global'
  tags: parBaseTagSet
}

resource resVnetLinkHub 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: varVirtualNetworkLinkName
  location: 'global'
  dependsOn: [
    resPrivateDnsZone
  ]
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: parVnetLinkId
    }
  }
}
