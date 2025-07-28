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

## Commander System

```mermaid
%%{init: {'theme': 'default'}}%%
C4Container
title Commander System
System_Ext(idp, "Identity Provider", "OIDC Provider")
Person(client, "Client", "Uses the public API")

System_Boundary(commanderSys, "Commander System") {
  Container_Ext(envoy, "Envoy Proxy", "sidercar")
  Container(commander, "Commander", "main")
  Container_Ext(daprd, "Daprd", "sidecar")
}
System(resourceId, "Resource ID Service")
System(actor, "Actor")

Rel(client, envoy, "Create/Update/Delete Operations", "REST")
Rel(envoy, idp, "JWS Keys", ".well-known")
Rel(envoy, commander, "Forward authenticated request", "HTTP")
Rel(commander, resourceId, "Get IDs", "DAPR")
Rel(commander, daprd, "Invoke DAPR Actor methods", "DAPR")
Rel(daprd, actor, "Forware request", "DAPRD-to-DAPRD")
```

## Resource Actor System

```mermaid
%%{init: {'theme': 'default'}}%%
C4Container
title Resource Actor System
System(commander, "Commander System")
System_Ext(cerbosRepo, "Cerbos Policy", "Cerbos Authorization Policy Repository")
System_Boundary(actorSys, "Actor System") {
  Container_Ext(daprd, "Daprd", "sidecar")
  ContainerDb_Ext(stateStore, "DAPR State Store", "State Store Component")
  ContainerQueue_Ext(pubSub, "DAPR Pub/Sub", "Pub/Sub Component")
  Container(actor, "DAPR Actor", "main")
  Container_Ext(cerbosPDP, "Cerbos Point Decision Policy", "sidecar")
}


Rel(commander, daprd, "Invoke DAPR Actor methods", "DAPR")
Rel(daprd, actor, "Invoke Actor methods", "DAPR")
Rel(daprd, stateStore, "Get/Set Actor States", "DAPR")
Rel(daprd, pubSub, "Publish change messages", "DAPR")
Rel(actor, cerbosPDP, "Check authorization", "Cerbos")
Rel(cerbosPDP, cerbosRepo, "Get Policies", "Cerbos")
```

## Resource ID System

```mermaid
%%{init: {'theme': 'default'}}%%
C4Container
title Resource ID System
```
