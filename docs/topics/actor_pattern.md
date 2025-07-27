# Actor Pattern

The Actor Pattern is a concurrency model that treats each actor as an independent unit of computation. Actors receive messages, process them sequentially, and manage their own state. This approach avoids shared mutable state and simplifies the reasoning about concurrent behavior.

Typical characteristics:
- **Message passing** is the only way to interact with an actor.
- **Isolation**: each actor's state is private and cannot be accessed directly.
- **Single-threaded execution**: an actor processes one message at a time.

Dapr provides a portable implementation of the Actor Pattern, allowing services written in different languages to create and manage actors via common APIs. In this project the `ResourceManager` component is implemented as a Dapr actor.
