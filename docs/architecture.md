# Architecture Diagrams

The following diagrams describe the cn-crud-app using the C4 model.

## System Context

![System Context](https://www.plantuml.com/plantuml/svg/ZP9FZzem4CNl-HHJJY0jvD9JJqi1RP5ssoXqrICozW1k7JkTiQ6qwdVlE6osq7zg3l5ayl9xR-pSSbGKK-DWTUA8pIpuY5zYyS9wxPB1H0xsCRRygYn97ISx6_TfanX9PwMF4nsQidNAPyYOet5sKyvUZglSUdouBnibN9BM-eazQKLP51KI1p_Cg1iOFCeoa7Kf4b8wCXp52U8UWRjWSB0AwiNgFKoh9Gz6nJdl-dL8tYWw3RNNb8mWj1_dQgpQTZ22RmN8bQsLzKX3YTieRphJMLzdvuuj0z49sc1zX6qWq8GguWsariWA8WQ33gKa_9oGOqvoRK388P76PSvIzm_pR7678X0EWqQATclHm2RfJoZZXYqaRuK9raYA_9Auoz03_sxreBpQTHFLrvriEfzMDKnr599jMeTDflkT6BD0cC65dTN_wLHH-8YPTU7rtCjkisx361gvarNEVfKP3nQFCWk51l0Wzfd_lIXgT4_7Vtaev-Xy5IOhBpI_RF7v860v_uVqvnQjq1lk7VilVfFzQU0gRPpblMHxdg9OlNdtONs_k5kydGz7nQsmvUV-0G==)

## Software Systems Overview

```mermaid
%%{init: {'theme': 'default'}}%%
C4Context
title Software Systems Overview
Person(client, "Client", "REST client of service")
System_Ext(idp, "Identity Provider", "OIDC Provider")
System_Boundary(cn-crud-app, "Cloud Native CRUD Application") {
  System(commander, "Commander")
  System(actor, "Actor")
  System(resourceId, "Resource ID Service")
  System_Ext(cerbosRepo, "Cerbos Policy", "Cerbos Authorization Policy Repository")
}

Rel(client, commander, "Create/Update/Delete Operations", "REST")
Rel(commander, actor, "Execute Operations", "DAPR")
Rel(commander, idp, "JWS Keys", ".well-known")
Rel(commander, resourceId, "Get IDs", "DAPR")
Rel(actor, cerbosRepo, "Authorization Policies", "cerbos")
```

## Commander Requests Unique IDs

![Commander Requests Unique IDs](https://www.plantuml.com/plantuml/svg/RP31JiCm38RlVOgmKoUnziA9qr0xGQKDfgAAuvIctXQjTORj2F7sf6WThTWfYVtbzoSlMJI9xrgLkQxJs02LyEc1XIkquLBa7DrPDArlm5EhZY9dVanJqb_9mShHrvw1Z4C1bCIuBZst6ll41KlJsZhD7XRRlbHjrccdMO12QPT_e-wiISw1ZA8j43kC-wXxDQl2CPj7MGZL5e5YCxY5vjLpGX2mysIWQ09I3e_y9hFHg0-_MUMq4kYeXFQYCHuwx4GP0YtMOK1xSiHC39xun6hlI1MvghqvWLm-ZAdf0F64_8-_CU1FF-jbWA-Ttl_zvUrZjruzhrxpU1uj0Pkmu1y=)

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
Rel(envoy, commander, "Forwards requests")
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
