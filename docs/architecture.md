# Architecture Diagrams

The following diagrams describe the cn-crud-app using the C4 model.

## System Context

```mermaid
%%{init: {'theme': 'default'}}%%
C4Context
title System Context
Person(client, "Client", "Uses the public API")
Person(idp, "Identity Provider", "OIDC provider")
System(commander, "Commander System", "Entry point service")
System(actor, "Resource Actor System", "Handles resource life-cycle")
System(resourceId, "Resource ID System", "Generates unique IDs")
System_Ext(cerbos, "Cerbos PDP", "Authorization")
Rel(client, commander, "HTTP via Envoy")
Rel(client, idp, "Authenticate")
Rel(commander, actor, "Invoke actors")
Rel(commander, resourceId, "Request IDs")
Rel(actor, cerbos, "AuthZ query")
```

## Container Overview

```mermaid
%%{init: {'theme': 'default'}}%%
C4Container
title cn-crud-app Container Diagram
Person(client, "Client", "Uses the public API")
Person(idp, "Identity Provider", "OIDC provider")
System_Boundary(cn, "cn-crud-app") {
  Container(envoy, "Envoy Proxy", "Gateway", "Authenticates JWTs")
  Container(commander, "Commander", "Service", "REST entry point")
  Container(resourceId, "ResourceID", "Service", "Generates unique IDs")
  Container(resourceManager, "ResourceManager", "Dapr Actor", "Resource logic")
  Container(resourceProjector, "ResourceProjector", "Service", "Materializes views")
  ContainerDb(stateStore, "State Store", "Database", "Actor state")
  ContainerDb(viewStore, "View Store", "Database", "Query data")
  Container(queue, "Event Broker", "Pub/Sub", "Domain events")
  Container_Ext(cerbos, "Cerbos PDP", "Authorization", "Policy decisions")
}
Rel(client, envoy, "HTTP")
Rel(envoy, idp, "Validate token")
Rel(envoy, commander, "Forwards requests")
Rel(commander, resourceId, "Request ID")
Rel(commander, resourceManager, "Invoke via Dapr")
Rel(resourceManager, stateStore, "Persist state")
Rel(resourceManager, queue, "Publish events")
Rel(resourceManager, cerbos, "AuthZ query")
Rel(resourceProjector, queue, "Consume events")
Rel(resourceProjector, viewStore, "Update views")
Rel(client, resourceProjector, "Query views")
```

## Commander System

```mermaid
%%{init: {'theme': 'default'}}%%
C4Container
title Commander System
Person(client, "Client", "Uses the public API")
System_Boundary(commanderSys, "Commander System") {
  Container(envoy, "Envoy Proxy", "Gateway", "Authenticates JWTs")
  Container(commander, "Commander Service", "Service", "REST entry point")
  Container(daprd, "Dapr Sidecar", "Sidecar", "Service invocation")
}
System_Ext(resourceId, "Resource ID System", "Generates unique IDs")
System_Ext(actorSys, "Resource Actor System", "Handles resource life-cycle")
Rel(client, envoy, "HTTP")
Rel(envoy, commander, "Forwarded requests")
Rel(commander, daprd, "Invoke actor")
Rel(commander, resourceId, "Request ID")
Rel(daprd, actorSys, "Invoke actor methods")
```

## Resource Actor System

```mermaid
%%{init: {'theme': 'default'}}%%
C4Container
title Resource Actor System
System_Boundary(actorSys, "Resource Actor System") {
  Container(actor, "ResourceManager", "Dapr Actor", "Resource logic")
  Container(actorDaprd, "Dapr Sidecar", "Sidecar", "Actor runtime")
  ContainerDb(stateStore, "State Store", "Database", "Actor state")
  Container(queue, "Event Broker", "Pub/Sub", "Domain events")
}
Container_Ext(cerbos, "Cerbos PDP", "Authorization", "Policy decisions")
System_Ext(commanderSys, "Commander System", "Invokes actor")
Rel(commanderSys, actorDaprd, "Invoke methods")
Rel(actorDaprd, actor, "Invoke actor")
Rel(actor, stateStore, "Persist state")
Rel(actor, queue, "Publish events")
Rel(actor, cerbos, "AuthZ query")
```

## Resource ID System

```mermaid
%%{init: {'theme': 'default'}}%%
C4Container
title Resource ID System
System_Boundary(resourceIdSys, "Resource ID System") {
  Container(service, "ResourceID Service", "Service", "Snowflake ID generator")
  Container(config, "Configuration", "Settings", "Datacenter and worker IDs")
}
System_Ext(commanderSys, "Commander System", "Requests IDs")
Rel(commanderSys, service, "HTTP")
Rel(service, config, "Reads")
```
