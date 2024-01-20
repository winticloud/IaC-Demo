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

var varAadTenant = 'https://login.microsoftonline.com/${tenant().tenantId}'
var varAadIssuer = 'https://sts.windows.net/${tenant().tenantId}/'
var varAadAudience = '41b23e61-6c1e-4545-b367-cd054e0ed4b4' //statice value for Azure VPN Client
var varAuthKey = base64('NeedsToBeChang3dAfterDepl0yment')

resource resVpnGwIPs 'Microsoft.Network/publicIPAddresses@2023-04-01' = [for i in range(0,3):{
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

resource resVpnNetworkGateway 'Microsoft.Network/virtualNetworkGateways@2023-04-01' = {
  name: parVngwName
  location: parLocation
  properties: {
    sku: {
      name: 'VpnGw1'
      tier: 'VpnGw1'
    }
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    enableBgp: true
    activeActive: true
    bgpSettings: {
      asn: parBgpAsnPgw
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
      }]
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
      }
  }
  tags: union(parBaseTagSet, {
    Description: 'virtual network gateway'
  })
}

resource resLocalNetworkGateway 'Microsoft.Network/localNetworkGateways@2023-04-01' = {
  name: parLocalGatewayName
  location: parLocation
  properties: {
    bgpSettings: {
      asn: parBgpAsnLgw
      bgpPeeringAddress: parBgpPeeringAddress
    }
    gatewayIpAddress: parCustomerPublicIP
  }
  tags: union(parBaseTagSet, {
    Description: 'local virtual network gateway'
  })
}

resource resLngwConnection 'Microsoft.Network/connections@2022-11-01' = {
  name: '${parLocalGatewayName}-conn1'
  location: parLocation
  properties: {
    authorizationKey: varAuthKey
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
