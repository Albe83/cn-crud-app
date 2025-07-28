# Cerbos

Cerbos is a lightweight, language-agnostic authorization service. It lets you define access control policies centrally and evaluate them from any application via an API. Policies are written in YAML or JSON and support both RBAC and ABAC models.

Advantages of using Cerbos:
- **Decoupling** authorization rules from application code.
- **Versioned policies** that can be tested and deployed like code.
- **Support for complex conditions** using attribute-based rules.

In a microservice environment Cerbos can run as a separate service or sidecar. Applications send an authorization request specifying the principal (user or service), the resource and the desired action. Cerbos evaluates the request against its policy store and returns an allow or deny decision.
