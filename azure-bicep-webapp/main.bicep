// Ejercicio Propuesto - Azure Bicep
// Despliega un App Service Plan (tier F1 Free) y una Web App asociada.

@description('Nombre del entorno')
@allowed([
  'dev'
  'qa'
  'prod'
])
param environmentName string = 'dev'

@description('Region donde desplegar los recursos')
param location string = resourceGroup().location

@description('Identificador del estudiante')
param studentId string = 'jbreategui'

@description('Sufijo unico para evitar colisiones de nombres globales')
param uniqueSuffix string

var planName = 'plan-${environmentName}-${studentId}-${uniqueSuffix}'
var webAppName = 'webapp-${environmentName}-${studentId}-${uniqueSuffix}'

var commonTags = {
  environment: environmentName
  studentId: studentId
  managedBy: 'Bicep'
}

resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: planName
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
    capacity: 1
  }
  properties: {
    reserved: false
  }
  tags: commonTags
}

resource webApp 'Microsoft.Web/sites@2023-12-01' = {
  name: webAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      minTlsVersion: '1.2'
      ftpsState: 'Disabled'
      http20Enabled: true
    }
  }
  tags: commonTags
}

output webAppUrl string = 'https://${webApp.properties.defaultHostName}'
output webAppName string = webApp.name
output appServicePlanId string = appServicePlan.id
