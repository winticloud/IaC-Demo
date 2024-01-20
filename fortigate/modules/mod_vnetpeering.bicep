param vnetName string
param vnetToPeer string
param vnetRemoteName string
param useRemoteGw bool
param allowGwTransit bool


resource resVnet 'Microsoft.Network/virtualNetworks@2023-02-01' existing = {
  name:vnetName
}

resource resPeerVirtualNetworks 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-02-01' = {
  name: 'peer-to-${vnetRemoteName}'
  parent: resVnet
  properties: {
    allowForwardedTraffic: true
    allowGatewayTransit: allowGwTransit
    allowVirtualNetworkAccess: true
    doNotVerifyRemoteGateways: true
    useRemoteGateways: useRemoteGw
    remoteVirtualNetwork: {
      id: vnetToPeer
    }
  }
}
