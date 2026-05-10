// Ejercicio Propuesto - Azure Bicep
// Despliega un Log Analytics Workspace y un Application Insights vinculado
// al workspace (Workspace-based App Insights).

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

@description('Sufijo unico')
param uniqueSuffix string

var workspaceName = 'log-${environmentName}-${studentId}-${uniqueSuffix}'
var appInsightsName = 'appi-${environmentName}-${studentId}-${uniqueSuffix}'

var commonTags = {
  environment: environmentName
  studentId: studentId
  managedBy: 'Bicep'
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: workspaceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
  tags: commonTags
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
    IngestionMode: 'LogAnalytics'
  }
  tags: commonTags
}

output workspaceId string = logAnalyticsWorkspace.id
output workspaceName string = logAnalyticsWorkspace.name
output appInsightsId string = appInsights.id
output appInsightsName string = appInsights.name
