# Introduction to Dapr

Dapr (Distributed Application Runtime) is an open source project that simplifies building distributed systems. It provides building blocks for service invocation, state management, pub/sub messaging, and other concerns required in microservice architectures. Dapr runs as a sidecar next to each service, so applications can remain language-agnostic.

Key benefits include:
- **Loose coupling** between services via standard HTTP or gRPC APIs.
- **Pluggable components** for state stores, messaging backends and secret stores.
- **Built-in observability** with metrics and tracing.

Dapr also supports an [Actor model](./actor_pattern.md) implementation for stateful, single-threaded objects. This repository uses Dapr to host actors that manage CRUD resources.
