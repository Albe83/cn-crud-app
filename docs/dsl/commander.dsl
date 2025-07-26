model {
    envoyProxy = component commander "Envoy Proxy" "Authenticates requests via OIDC and enforces rate limiting and circuit breaker" "Envoy"
    mainApplication = component commander "Main Application" "Organizes identity data and invokes the Resource Manager" "Go"

    user -> envoyProxy "HTTP request"
    envoyProxy -> mainApplication "Forward authenticated request"
    mainApplication -> resourceManager "Invoke actor"
}

views {
    component commander "CommanderComponents" {
        include envoyProxy
        include mainApplication
        include resourceManager
        include user
        autolayout lr
    }
}
