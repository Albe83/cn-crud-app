# Resource Creation Workflow

This document describes the detailed workflow executed when a client issues a request to create a new resource through the **Commander** service.

## Overview
The process starts with an authenticated REST request. The request travels through the Envoy proxy, reaches the Commander application and eventually triggers an actor running in Dapr. The actor performs the validation and authorization steps and persists the resource state if all checks pass.

A graphical representation of the sequence is available in [commander_sequence.mmd](commander_sequence.mmd). The diagram groups containers into pods and numbers each step for clarity.

## Steps
1. **Client request** – The client sends an HTTP request to the Commander endpoint. The request carries a JWT issued by the Identity Provider.
2. **Authentication** – Envoy Proxy validates the integrity and authenticity of the JWT using OIDC configuration.
3. **Forwarding** – After successful validation the proxy forwards the request to the main application container of Commander.
4. **Actor invocation** – The main application calls Dapr's sidecar (`daprd`) to invoke `createResource` on the appropriate actor. The actor ID has been issued by the *ResourceID* service and the actor type matches the configured resource type.
5. **State check** – The actor retrieves its state and verifies the `metadata.created` attribute. If the attribute is already set the actor returns `409 Conflict`.
6. **Temporary resource creation** – When the resource does not exist the actor merges default values with the payload from the request and assigns its own identifier to the new resource instance.
7. **Schema validation** – The temporary resource is validated against the configured schema. If validation fails the actor returns `422 Unprocessable Entity`.
8. **Authorization** – The actor queries the Cerbos PDP sidecar, passing the temporary resource and the user's JWT. A `403 Forbidden` response is returned if the action is denied.
9. **State persistence** – When authorization succeeds the actor stores the resource in its state, updates the `metadata` fields (including the ETag and creation timestamp) and persists the state.
10. **Domain event** – After saving the state the actor emits a domain event notifying other services of the new resource creation.
11. **Response** – The actor responds with `201 Created` and the generated resource ID. Commander relays this response back to the client.

