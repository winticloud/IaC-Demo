param parLocation string
param parBastionHostName string
param parHubVnet string
param parHubVnetRg string
param parBaseTagSet object

resource resBastionPublicIP 'Microsoft.Network/publicIPAddresses@2023-02-01' = {
  name: '${parBastionHostName}-pip'
  location: parLocation
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  tags: parBaseTagSet
}

resource resBastionNsg 'Microsoft.Network/networkSecurityGroups@2023-02-01' = {
  name: '${parHubVnet}-nsg-AzureBastionSubnet'
  location: parLocation
  tags: parBaseTagSet
  properties: {
    securityRules: [
      // Inbound Rules
      {
        name: 'AllowHttpsInbound'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 120
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
        }
      }
      {
        name: 'AllowGatewayManagerInbound'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 130
          sourceAddressPrefix: 'GatewayManager'
          destinationAddressPrefix: '*'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
        }
      }
      {
        name: 'AllowAzureLoadBalancerInbound'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 140
          sourceAddressPrefix: 'AzureLoadBalancer'
          destinationAddressPrefix: '*'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
        }
      }
      {
        name: 'AllowBastionHostCommunication'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 150
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRanges: [
            '8080'
            '5701'
          ]
        }
      }
      {
        name: 'DenyAllInbound'
        properties: {
          access: 'Deny'
          direction: 'Inbound'
          priority: 4096
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
        }
      }
      // Outbound Rules
      {
        name: 'AllowSshRdpOutbound'
        properties: {
          access: 'Allow'
          direction: 'Outbound'
          priority: 100
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'VirtualNetwork'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRanges: [
            '22'
            '3389'
          ]
        }
      }
      {
        name: 'AllowAzureCloudOutbound'
        properties: {
          access: 'Allow'
          direction: 'Outbound'
          priority: 110
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'AzureCloud'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
        }
      }
      {
        name: 'AllowBastionCommunication'
        properties: {
          access: 'Allow'
          direction: 'Outbound'
          priority: 120
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRanges: [
            '8080'
            '5701'
          ]
        }
      }
      {
        name: 'AllowGetSessionInformation'
        properties: {
          access: 'Allow'
          direction: 'Outbound'
          priority: 130
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'Internet'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '80'
        }
      }
      {
        name: 'DenyAllOutbound'
        properties: {
          access: 'Deny'
          direction: 'Outbound'
          priority: 4096
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
        }
      }
    ]
  }
}

resource resBastionHost 'Microsoft.Network/bastionHosts@2023-02-01' = {
  name: parBastionHostName
  location: parLocation
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: resourceId(subscription().subscriptionId,parHubVnetRg,'Microsoft.Network/virtualNetworks/Subnets',parHubVnet,'AzureBastionSubnet')
          }
          publicIPAddress: {
            id: resBastionPublicIP.id
          }
        }
      }
    ]
  }
  tags: parBaseTagSet
}
