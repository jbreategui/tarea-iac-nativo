# Tarea — IaC con Herramientas Nativas (Módulo 4 · Clase S02)

**Estudiante:** Juan Breategui (`jbreategui`)
**Repositorio base:** [enterprise-architecture-utec/m04-infra-as-code-s02](https://github.com/enterprise-architecture-utec/m04-infra-as-code-s02)

Entregable: implementar **2 recursos a elección** en cada una de las 3 herramientas nativas de IaC vistas en clase. Los recursos elegidos no se solapan con los de los ejemplos guiados (VPC/S3, Storage Account, Key Vault).

## Estructura

```
clase3/
├── aws-sns-sqs/              ← Ejercicio 1 - AWS CloudFormation
│   ├── template.yaml
│   ├── parameters.json
│   └── README.md
├── azure-bicep-webapp/       ← Ejercicio 2 - Azure Bicep
│   ├── main.bicep
│   ├── main.bicepparam
│   └── README.md
└── azure-arm-cosmos/         ← Ejercicio 3 - Azure ARM
    ├── azuredeploy.json
    ├── azuredeploy.parameters.json
    └── README.md
```

## Resumen de los ejercicios

| # | Carpeta | Plataforma | Herramienta | Recursos elegidos |
|---|---------|------------|-------------|-------------------|
| 1 | `aws-sns-sqs/` | AWS | CloudFormation | SNS Topic + SQS Queue (suscripción) |
| 2 | `azure-bicep-webapp/` | Azure | Bicep | Log Analytics Workspace + Application Insights |
| 3 | `azure-arm-cosmos/` | Azure | ARM Templates | Cosmos DB Serverless + SQL Database |

## Criterios de elección de recursos

- **Bajo costo / free tier**: todos los recursos se mantienen dentro del free tier o son serverless con costo casi nulo durante la verificación.
- **Demuestran integración**: cada par muestra una dependencia real entre recursos (suscripción SNS→SQS, Web App sobre Plan, Database dentro de Account).
- **No duplican los ejemplos guiados** del repositorio del curso.

## Cómo ejecutar cada ejercicio

Cada carpeta tiene su propio `README.md` con los comandos completos (validar / preview / deploy / verificar / limpiar). El flujo común es el del repo base:

```
validar → preview (what-if) → deploy → verificar → eliminar
```

> ⚠️ **Importante:** ejecutar la limpieza al finalizar cada ejercicio para no generar costos innecesarios (siguiendo la recomendación explícita del README del curso).

## Prerrequisitos globales

| Herramienta | Versión mínima |
|-------------|----------------|
| AWS CLI | 2.x |
| Azure CLI | 2.50+ |
| Bicep CLI | 0.24+ |
