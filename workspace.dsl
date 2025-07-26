workspace {
    model {
        user = person "User" "Interacts with the system via REST APIs"
        system = softwareSystem "cn-crud-app" "CRUD microservice sample"
        commander = container system "Commander" "REST entry point for create, update and delete requests"
        resourceId = container system "ResourceID" "Generates certified buckets of unique identifiers for resources"
        resourceManager = container system "ResourceManager" "DAPR Actor implementing business logic for resources"
        resourceProjector = container system "ResourceProjector" "Creates materialized views from events"

        user -> commander "Manages resources"
        commander -> resourceId "Requests IDs"
        commander -> resourceManager "Sends commands"
        resourceManager -> resourceProjector "Publishes events"
    }

    views {
        container system "SystemContext" {
            include *
            autolayout lr
        }

        dynamic system "Commander requests unique IDs" {
            user -> commander "Requests creation"
            commander -> resourceId "Asks for ID bucket"
            resourceId -> commander "Returns ID bucket"
            commander -> resourceManager "Creates resource"
        }
    }
}
