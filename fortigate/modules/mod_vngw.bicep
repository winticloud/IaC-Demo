param parLocation string
param parVngwName string
param parBgpAsnPgw int
param parBgpAsnLgw int
param parBgpPeeringAddress string
param parLocalGatewayName string
param parP2sVpnSubnetPrefix string
param parCustomerPublicIP string
param parHubVnet string
param parBaseTagSet object
param parDeployVpnGw bool

var varAadTenant = 'https://login.microsoftonline.com/${tenant().tenantId}'
var varAadIssuer = 'https://sts.windows.net/${tenant().tenantId}/'
var varAadAudience = '41b23e61-6c1e-4545-b367-cd054e0ed4b4' //statice value for Azure VPN Client
//create random string for auth key 


// var varAuthKey = base64('NeedsToBeChang3dAfterDepl0yment')
param parAuthKey string = 'uniqueString(newGuid(), utcNow())'

resource resVpnGwIPs 'Microsoft.Network/publicIPAddresses@2023-04-01' = [for i in range(0,3): {
  name: '${parVngwName}-pip${i+1}'
  location: parLocation
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    publicIPAddressVersion: 'IPv4'
    dnsSettings: {
      domainNameLabel: '${parVngwName}-pip${i+1}'
    }
  }
  tags: union(parBaseTagSet, {
    Description: 'virtual network gateway public IP address'
  }) 
}]

//https://learn.microsoft.com/en-us/azure/templates/microsoft.network/virtualnetworkgateways?pivots=deployment-language-bicep
resource resVpnNetworkGateway 'Microsoft.Network/virtualNetworkGateways@2023-04-01' = {
  name: parVngwName
  location: parLocation
  tags: union(parBaseTagSet, {
    Description: 'virtual network gateway'
  })
  properties: {
    sku: {
      name: 'VpnGw1'
      tier: 'VpnGw1'
    }
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    vpnGatewayGeneration: 'Generation1'
    enableBgp: true
    activeActive: true
    adminState: 'Enabled'
    allowRemoteVnetTraffic: true
    disableIPSecReplayProtection: false
    enableBgpRouteTranslationForNat: false
    enableDnsForwarding: false
    enablePrivateIpAddress: false
    customRoutes: {
      addressPrefixes: [
        '192.168.168.0/24'
        ]}
    bgpSettings: {
      asn: parBgpAsnPgw
      bgpPeeringAddress: parBgpPeeringAddress
      /*

      bgpPeeringAddresses: [
        {
          customBgpIpAddresses: [
            'string'
          ]
          ipconfigurationId: 'string'
        }
      ]
      peerWeight: int*/
    }
    ipConfigurations: [for i in range(0,3): {
      name: 'vnetGatewayConfig${i+1}'
      properties: {
        subnet: {
          id: resourceId('Microsoft.Network/virtualNetworks/subnets', parHubVnet, 'GatewaySubnet')
        }
        publicIPAddress:{
          id:  resVpnGwIPs[i].id
        }
        }
      }
    ]
      vpnClientConfiguration: {
        vpnClientAddressPool: {
          addressPrefixes: [
            parP2sVpnSubnetPrefix
          ]
        }
        vpnClientProtocols: [
          'OpenVPN'
        ]
        vpnAuthenticationTypes: [
          'AAD'
        ]
        aadTenant: varAadTenant
        aadAudience: varAadAudience
        aadIssuer: varAadIssuer
        vpnClientIpsecPolicies: [
          {
            ipsecEncryption: 'GCMAES256'
            ipsecIntegrity: 'GCMAES256'
            ikeEncryption: 'GCMAES256'
            ikeIntegrity: 'SHA384'
            dhGroup: 'ECP384'
            pfsGroup: 'ECP384'
            saLifeTimeSeconds: 27000
            saDataSizeKilobytes: 102400000
          }
        ]
      }
  }
}

resource resLocalNetworkGateway 'Microsoft.Network/localNetworkGateways@2023-04-01' = {
  name: parLocalGatewayName
  location: parLocation
  tags: union(parBaseTagSet, {
    Description: 'local virtual network gateway'
  })
  properties: {
    bgpSettings: {
      asn: parBgpAsnLgw
      bgpPeeringAddress: parBgpPeeringAddress
    }
    gatewayIpAddress: parCustomerPublicIP
  }
}

resource resLngwConnection 'Microsoft.Network/connections@2022-11-01' = {
  name: '${parLocalGatewayName}-conn1'
  location: parLocation
  tags: union(parBaseTagSet, {
    Description: 'local virtual network gateway connection'
  })
  properties: {
    // The authorization key is used for authentication and encryption purposes in the IPsec connection.
    authorizationKey: parAuthKey
    connectionType: 'IPsec'
    connectionProtocol: 'IKEv2'
    connectionMode: 'Default'
    enableBgp: true
    ipsecPolicies: [
      {
        saLifeTimeSeconds: 27000
        saDataSizeKilobytes: 102400000
        ipsecEncryption: 'GCMAES256'
        ipsecIntegrity: 'GCMAES256'
        ikeEncryption: 'GCMAES256'
        ikeIntegrity: 'SHA256'
        dhGroup: 'ECP384'
        pfsGroup: 'ECP384'
      }
    ]
    useLocalAzureIpAddress: false
    usePolicyBasedTrafficSelectors:false
    routingWeight: 0
    virtualNetworkGateway1: {
      id: resVpnNetworkGateway.id
    }    
    localNetworkGateway2: {
      id: resLocalNetworkGateway.id
    }
    dpdTimeoutSeconds: 45

  }
}
