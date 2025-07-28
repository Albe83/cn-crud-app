# cn-crud-app

`cn-crud-app` is a didactic yet production-ready project. Its main goal is to demonstrate how to build a **Cloud Native** application implementing standard CRUD logic while following the principles of **Microservices**, **Domain-Driven Design** (DDD) and **GRASP**.

The system provides a scalable infrastructure for managing generic resources using CRUD operations. It relies on **Event Sourcing**, the **DAPR Actor Model**, and the **CQRS** pattern to ensure consistency, auditing capabilities, horizontal scalability, and a clear separation between write and read paths.

## Project Goals
- Demonstrate the creation of CRUD services with a microservices architecture
- Show how DDD and GRASP patterns can guide design decisions
- Provide a starting point for exploring Cloud Native applications

## Structure
The project is organized into multiple services (or bounded contexts) that represent separate domains. Each service exposes RESTful APIs for data management and can be launched in Docker containers. The architecture can be extended by adding new contexts in a modular way.

## Architecture Overview
The core components of the system are:

- **Commander**: Acts as the REST entry point for create, update and delete requests.
  It allows clients to manage resources through standard HTTP calls.
- **ResourceID**: A technical microservice that encapsulates the logic for generating
  unique identifiers for resources.
- **ResourceManager**: Implemented as a DAPR Actor, it contains the business logic
  for creating, modifying and deleting resources.
 - **ResourceProjector**: Translates events produced by the ResourceManager into
  materialized views so that they can be queried with more complex filters.

The `docs/dsl/workspace.dsl` file contains a Structurizr representation of this architecture. A PlantUML version of the same C4 model is available at `docs/puml/workspace.puml`. You can view the rendered diagrams in [docs/architecture.md](docs/architecture.md).

## Prerequisites
Make sure you have installed:
- [Docker](https://www.docker.com/) to run the services
- [Docker Compose](https://docs.docker.com/compose/) to orchestrate the containers
- A modern JDK such as [OpenJDK](https://openjdk.org/) if you develop microservices in Java

## Quick Start
A generic example of the steps required to set up the environment:

```bash
# Clone the repository
$ git clone <repository-url>
$ cd cn-crud-app

# Build the images and start the containers
$ docker compose up --build
```

Once the services are running, you can interact with the CRUD APIs via HTTP.

## Contributing
Contributions are welcome! Feel free to open an issue or send a pull request for improvements or bug reports.

## License
The project is distributed under the [MIT](LICENSE) license.
