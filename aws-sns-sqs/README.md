# Ejercicio Propuesto - AWS CloudFormation

Despliegue de un patrón **pub/sub** mínimo en AWS usando CloudFormation:

- **Amazon SNS Topic** — recibe los mensajes publicados.
- **Amazon SQS Queue** — suscrita al topic; recibe cada mensaje publicado.

Se incluye una `AWS::SQS::QueuePolicy` que autoriza a SNS a entregar mensajes a la cola, y una `AWS::SNS::Subscription` que conecta ambos recursos.

## Recursos creados

| Recurso | Tipo CloudFormation |
|---------|---------------------|
| Topic SNS | `AWS::SNS::Topic` |
| Queue SQS | `AWS::SQS::Queue` |
| Policy de la cola | `AWS::SQS::QueuePolicy` |
| Suscripción topic→queue | `AWS::SNS::Subscription` |

> Los **2 recursos principales** del entregable son **SNS Topic** y **SQS Queue**. La policy y la subscription son recursos de soporte para que la integración funcione.

## Diagrama de arquitectura

```mermaid
flowchart LR
    Pub["Publisher<br/>(aws sns publish)"]
    subgraph AWS["AWS Account · CloudFormation Stack"]
        direction LR
        Topic(["SNS Topic<br/>NotificationTopic"])
        Sub{{"SNS Subscription<br/>protocol: sqs"}}
        Queue[("SQS Queue<br/>MessageQueue")]
        Policy["QueuePolicy<br/>(allow sns:SendMessage)"]
        Topic -->|fan-out| Sub
        Sub -->|deliver| Queue
        Policy -. authorizes .-> Queue
    end
    Cons["Consumer<br/>(aws sqs receive-message)"]
    Pub -->|publish| Topic
    Queue -->|poll| Cons

    classDef principal fill:#ff9,stroke:#333,stroke-width:2px
    class Topic,Queue principal
```

> Los nodos resaltados (Topic y Queue) son los **2 recursos principales** del entregable.

## Prerrequisitos

- AWS CLI v2 configurado (`aws configure`)
- Credenciales con permisos para SNS, SQS y CloudFormation
- Región por defecto definida (`us-east-1`, por ejemplo)

## Despliegue

### 1. Validar la plantilla

```powershell
aws cloudformation validate-template --template-body file://template.yaml
```

### 2. Crear el stack

```powershell
aws cloudformation create-stack `
  --stack-name iac-aws-sns-sqs-jbreategui `
  --template-body file://template.yaml `
  --parameters file://parameters.json `
  --tags Key=Module,Value=M04 Key=Class,Value=S02
```

### 3. Esperar a que termine

```powershell
aws cloudformation wait stack-create-complete --stack-name iac-aws-sns-sqs-jbreategui
```

### 4. Ver outputs

```powershell
aws cloudformation describe-stacks `
  --stack-name iac-aws-sns-sqs-jbreategui `
  --query "Stacks[0].Outputs"
```

## Verificación funcional

Publicar un mensaje en el topic y leerlo desde la cola:

```powershell
$topicArn = (aws cloudformation describe-stacks --stack-name iac-aws-sns-sqs-jbreategui --query "Stacks[0].Outputs[?OutputKey=='TopicArn'].OutputValue" --output text)
$queueUrl = (aws cloudformation describe-stacks --stack-name iac-aws-sns-sqs-jbreategui --query "Stacks[0].Outputs[?OutputKey=='QueueUrl'].OutputValue" --output text)

aws sns publish --topic-arn $topicArn --message "hola desde IaC"
aws sqs receive-message --queue-url $queueUrl --wait-time-seconds 5
```

## Limpieza

```powershell
aws cloudformation delete-stack --stack-name iac-aws-sns-sqs-jbreategui
aws cloudformation wait stack-delete-complete --stack-name iac-aws-sns-sqs-jbreategui
```
