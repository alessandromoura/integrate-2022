@description('Environment where the resouce will be deployed')
param environment string = 'dev'

@description('The Azure region into which the resources should be deployed.')
param location string

@description('Storage account name.')
param storageAccountName string

@description('Storage account kind')
param storageAccountKind string

var environmentConfigMap = {
  prod: {
    storageAccount: {
      sku: {
        name: 'Standard_ZRS'
      }
      accessTier: 'Hot'
    }
  }
  nonprod: {
    storageAccount: {
      sku: {
        name: 'Standard_LRS'
      }
      accessTier: 'Hot'
    }
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageAccountName
  location: location
  sku: ((environment == 'prod') ? environmentConfigMap['prod'].storageAccount.sku : environmentConfigMap['nonprod'].storageAccount.sku)
  kind: storageAccountKind
  properties: {
    defaultToOAuthAuthentication: false
    allowCrossTenantReplication: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: true
    allowSharedKeyAccess: true
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
  }
}

output storageEndpoint object = storageAccount.properties.primaryEndpoints
