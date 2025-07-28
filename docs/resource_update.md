# Resource Update Workflow

This document explains the workflow executed when a client updates an existing resource through the **Commander** service.

## Overview
The update operation starts with an authenticated request carrying the resource identifier and the attributes to change. The request is processed by the Envoy proxy, forwarded to the Commander application and eventually handled by a Dapr actor. The actor ensures that the resource already exists, applies the modifications, validates the resulting state and enforces authorization rules.

A graphical representation of the sequence is available in [commander_update_sequence.mmd](commander_update_sequence.mmd). The diagram groups containers into pods and numbers each step for clarity.

## Steps
1. **Client request** – The client issues a PUT request to Commander, including the resource ID in the path and a JWT signed as a JWS.
2. **Authentication** – Envoy Proxy verifies the JWS and ensures the token is valid.
3. **Forwarding** – After successful validation the proxy forwards the request to the main application container.
4. **Actor invocation** – The application sends the request to its local Dapr sidecar which forwards it to the target actor. The actor ID corresponds to the requested resource ID.
5. **State retrieval** – The actor loads its current state. If the resource has never been created it returns `404 Not Found`.
6. **Apply changes** – The actor merges the stored state with the attributes from the request.
7. **Schema validation** – The updated resource is validated against the configured schema. If validation fails the actor returns `422 Unprocessable Entity`.
8. **Authorization** – The actor queries the Cerbos PDP sidecar to check whether the user is allowed to perform the update. A `403 Forbidden` response is returned when the action is denied.
9. **State persistence** – When authorization succeeds the actor stores the updated resource, updates the `metadata` fields (including the ETag) and persists the state.
10. **Domain event** – After saving the state the actor emits an event describing the modification.
11. **Response** – The actor responds with `200 OK` and the updated resource data. Commander relays this response back to the client.
