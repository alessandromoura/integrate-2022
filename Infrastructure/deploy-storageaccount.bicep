@description('Environment where the resouce will be deployed')
param environment string = 'dev'

@description('The Azure region into which the resource will be deployed')
param location string = resourceGroup().location

@description('Storage account name')
param storageAccountName string

@description('Storage account kind')
param storageAccountType string

@description('Date suffix for deployment name')
param deploymentDateSuffix string = utcNow('yyyyMMdd')

var storageAccountNameVar = toLower('${storageAccountName}${environment}')

module storageAccnt 'modules/resource-storageaccount.bicep'= {
  name: '${storageAccountNameVar}-${deploymentDateSuffix}'
  params: {
    environment: environment
    location: location
    storageAccountKind: storageAccountType
    storageAccountName: storageAccountNameVar
  }
}

output storageEndpoint object = storageAccnt.outputs.storageEndpoint
