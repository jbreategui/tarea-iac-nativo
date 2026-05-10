# Ejercicio Propuesto - Azure ARM Templates

Despliegue de **Azure Cosmos DB** en modo **Serverless** con una base de datos SQL anidada, usando una plantilla ARM clásica (JSON).

## Recursos creados

| Recurso | Tipo |
|---------|------|
| Cosmos DB Account | `Microsoft.DocumentDB/databaseAccounts` (capability `EnableServerless`) |
| SQL Database | `Microsoft.DocumentDB/databaseAccounts/sqlDatabases` |

> Modo Serverless: pagas por **request unit consumida**, sin throughput aprovisionado. Ideal para cargas intermitentes y para no incurrir en costos fijos durante la entrega.

## Diagrama de arquitectura

```mermaid
flowchart LR
    Client["Cliente / App<br/>(SDK · REST · az cosmosdb)"]
    subgraph RG["Resource Group · rg-iac-arm-jbreategui"]
        direction TB
        Account["Cosmos DB Account<br/>Microsoft.DocumentDB/databaseAccounts<br/>kind: GlobalDocumentDB<br/>capability: EnableServerless"]
        DB[("SQL Database<br/>databaseAccounts/sqlDatabases<br/>name: appdb")]
        Account -->|dependsOn<br/>(parent / child)| DB
    end
    Client -->|HTTPS · SQL API<br/>documentEndpoint| Account

    classDef principal fill:#cfc,stroke:#363,stroke-width:2px
    class Account,DB principal
```

> El recurso `sqlDatabases` es **child** del `databaseAccounts` — su nombre se construye como `{cuenta}/{database}` y depende explícitamente de la cuenta vía `dependsOn`.

## Prerrequisitos

- Azure CLI ≥ 2.50
- Sesión iniciada (`az login`) y suscripción seleccionada
- Permisos para crear recursos en el resource group

## Despliegue

### 1. Crear el Resource Group

```powershell
az group create --name rg-iac-arm-jbreategui --location eastus
```

### 2. Validar la plantilla

```powershell
az deployment group validate `
  --resource-group rg-iac-arm-jbreategui `
  --template-file azuredeploy.json `
  --parameters azuredeploy.parameters.json
```

### 3. Preview con `what-if`

```powershell
az deployment group what-if `
  --resource-group rg-iac-arm-jbreategui `
  --template-file azuredeploy.json `
  --parameters azuredeploy.parameters.json
```

### 4. Desplegar

```powershell
az deployment group create `
  --resource-group rg-iac-arm-jbreategui `
  --name deploy-arm-cosmos `
  --template-file azuredeploy.json `
  --parameters azuredeploy.parameters.json
```

### 5. Ver outputs

```powershell
az deployment group show `
  --resource-group rg-iac-arm-jbreategui `
  --name deploy-arm-cosmos `
  --query properties.outputs
```

## Verificación

```powershell
# Listar la cuenta
az cosmosdb show --resource-group rg-iac-arm-jbreategui --name <cosmosAccountName>

# Listar las bases de datos
az cosmosdb sql database list --resource-group rg-iac-arm-jbreategui --account-name <cosmosAccountName>
```

## Limpieza

```powershell
az group delete --name rg-iac-arm-jbreategui --yes --no-wait
```
