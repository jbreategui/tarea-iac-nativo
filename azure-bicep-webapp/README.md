# Ejercicio Propuesto - Azure Bicep

Despliegue de una **Web App** en Azure usando Bicep, sobre un **App Service Plan** en tier gratuito (F1).

## Recursos creados

| Recurso | Tipo |
|---------|------|
| App Service Plan | `Microsoft.Web/serverfarms` (sku F1 Free) |
| Web App | `Microsoft.Web/sites` |

> Demuestra el patrón típico Bicep con **dependencia implícita**: la Web App referencia `appServicePlan.id`, por lo que Bicep deduce el orden de despliegue sin necesidad de `dependsOn` explícito.

## Prerrequisitos

- Azure CLI ≥ 2.50 (`az --version`)
- Bicep CLI ≥ 0.24 (`az bicep version`)
- Sesión iniciada (`az login`) y suscripción seleccionada (`az account set --subscription <id>`)

> Nota: el tier **F1 Free** está limitado a **1 App Service Plan gratuito por suscripción y región**. Si ya tienes uno, cambia `sku.name` a `B1` (≈ $13/mes) o usa otro Resource Group en otra región.

## Despliegue

### 1. Crear el Resource Group

```powershell
az group create --name rg-iac-bicep-jbreategui --location eastus
```

### 2. Lint + build (validación local)

```powershell
az bicep build --file main.bicep
```

### 3. Preview con `what-if`

```powershell
az deployment group what-if `
  --resource-group rg-iac-bicep-jbreategui `
  --template-file main.bicep `
  --parameters main.bicepparam
```

### 4. Desplegar

```powershell
az deployment group create `
  --resource-group rg-iac-bicep-jbreategui `
  --name deploy-bicep-webapp `
  --template-file main.bicep `
  --parameters main.bicepparam
```

### 5. Ver outputs

```powershell
az deployment group show `
  --resource-group rg-iac-bicep-jbreategui `
  --name deploy-bicep-webapp `
  --query properties.outputs
```

## Verificación

Abrir la URL devuelta en `webAppUrl` — debería mostrar la página de bienvenida de App Service.

## Limpieza

```powershell
az group delete --name rg-iac-bicep-jbreategui --yes --no-wait
```
