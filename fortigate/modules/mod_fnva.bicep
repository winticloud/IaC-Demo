param parLocation string
param parPublicSubnetId string
param parPrivateSubnetId string
param parBaseTagSet object
param parFortiName string
param parFortiInstance string
param parFortiImageVersion string
param parFortiImageSku string
param parFortiPrivateNicIp string
param parFortiPublicNicIp string
param parAdminUsername string
param parDescription string = 'Azure Bastion Host'
@secure()
param parAdminPassword string

/*
resource resRouteTables 'Microsoft.Network/routeTables@2023-04-01' = {
  name: 'whatevs'
  location: location
  properties: {
    routes: [
      {
        name: 'VirtualNetwork'
        properties: {
          addressPrefix: 
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: fortiPrivateIp
        }
      }
      {
        name: 'Subnet'
        properties: {
          addressPrefix:
          nextHopType: 'VnetLocal'
        }
      }
      {
        name: 'Default'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: fortiPrivateIp
        }
      }
    ]
    disableBgpRoutePropagation: false
  }
}
*/
resource resPublicIp 'Microsoft.Network/publicIPAddresses@2023-04-01' = {
  name: '${parFortiName}-pip1'
  location: parLocation
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource resFortiNsg 'Microsoft.Network/networkSecurityGroups@2023-02-01' = {
  name: '${parFortiName}-nsg'
  location: parLocation
  tags: union(parBaseTagSet, {
      Description: '${parFortiName}-nsg'
    })
  properties: {
    securityRules: [
      // Inbound Rules
      {
        name: 'AllowInternetInbound'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 120
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '*'
        }
      }
    
      // Outbound Rules
      {
        name: 'AllowInternetOutbound'
        properties: {
          access: 'Allow'
          direction: 'Outbound'
          priority: 120
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'Internet'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
        }
      }
    ]
  }
}

resource resFortiPublicNic 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  name: '${parFortiName}-nic1'
  location: parLocation
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: parFortiPublicNicIp
          privateIPAllocationMethod: 'Static'
          publicIPAddress: {
            id: resPublicIp.id
          }
          subnet: {
            id: parPublicSubnetId
          }
        }
      }
    ]
    enableIPForwarding: true
    enableAcceleratedNetworking: true
    networkSecurityGroup: {
      id: resFortiNsg.id
    }
  }
}

resource resFortiPrivateNic 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  name: '${parFortiName}-nic2'
  location: parLocation
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: parFortiPrivateNicIp
          privateIPAllocationMethod: 'Static'
          subnet: {
            id: parPrivateSubnetId
          }
        }
      }
    ]
    enableIPForwarding: true
    enableAcceleratedNetworking: true
    networkSecurityGroup: {
      id: resFortiNsg.id
    }
  }
}

resource resFortiVm 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: parFortiName
  location: parLocation
  tags: union(parBaseTagSet, {
  Publisher: 'Fortinet'
  Provider:  '6EB3B02F-50E5-4A3E-8CB8-2E12925831VM'
  })
  identity: {
    type: 'SystemAssigned'
  }
  plan: {
    name: parFortiImageSku
    publisher: 'fortinet'
    product: 'fortinet_fortigate-vm_v5'
  }
  properties: {
    hardwareProfile: {
      vmSize: parFortiInstance
    }
    osProfile: {
      computerName: parFortiName
      adminUsername: parAdminUsername
      adminPassword: parAdminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'Fortinet'
        offer: 'fortinet_fortigate-vm_v5'
        sku: parFortiImageSku
        version: parFortiImageVersion
      }
      osDisk: {
        createOption: 'FromImage'
        name: '${parFortiName}-odsk'
        managedDisk: {
         storageAccountType: 'StandardSSD_LRS'
        }
      }
      dataDisks: [
        {
          diskSizeGB: 32
          lun: 0
          createOption: 'Empty'
          name: '${parFortiName}-ddsk1'
          managedDisk: {
            storageAccountType: 'StandardSSD_LRS'
          }
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          properties: {
            primary: true
          }
          id: resFortiPublicNic.id
        }
        {
          properties: {
            primary: false
          }
          id: resFortiPrivateNic.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}
