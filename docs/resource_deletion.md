# Resource Deletion Workflow

This document explains how the system processes a request to delete an existing resource using the **Commander** service.

## Overview
The flow is similar to the creation scenario but triggers the `deleteResource` method on the resource actor. Authorization and state management are handled before the resource is marked for removal and scheduled for cleanup.

A graphical representation of the sequence is available in [commander_delete_sequence.mmd](commander_delete_sequence.mmd). The diagram groups containers into pods and numbers each step for clarity.

## Steps
1. **Client request** – The client sends an HTTP `DELETE` request to the Commander endpoint with the resource identifier and a valid JWT.
2. **Authentication** – Envoy Proxy validates the JWT using the configured OIDC provider.
3. **Forwarding** – After validation the proxy forwards the request to the Commander application.
4. **Actor invocation** – Commander calls its local Dapr sidecar, which forwards the invocation to the resource actor's sidecar. The actor type and ID resolve to the targeted resource.
5. **State check** – The actor loads the current state. If no state exists the actor returns `404 Not Found`.
6. **Authorization** – When the resource exists the actor queries Cerbos with the state and the user's JWT. A `403 Forbidden` response is returned if the deletion is denied.
7. **Soft delete** – If allowed the actor sets `.metadata.deleted` to the current timestamp, persists the new state through Dapr and registers a reminder for physical deletion.
8. **Domain event** – The actor emits a domain event notifying other services about the deletion.
9. **Response** – The actor responds with `204 No Content`. Commander relays this status to the client.
10. **Cleanup reminder** – When the reminder fires Dapr calls the actor again. If the deletion timestamp is older than the configured threshold the actor permanently removes the state.
