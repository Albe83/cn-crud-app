# RBAC and ABAC

Role-Based Access Control (RBAC) and Attribute-Based Access Control (ABAC) are common models for managing permissions.

## RBAC
In RBAC, permissions are granted to roles and users are assigned one or more roles. Authorization decisions are easy to understand because they rely on a static mapping between roles and actions.

## ABAC
ABAC introduces greater flexibility by evaluating attributes of the user, resource, and environment when making decisions. Policies can express conditions such as time of day, ownership of a resource, or any other metadata.

Systems like Cerbos can combine RBAC and ABAC by defining roles as well as attribute-based rules. This hybrid approach allows simple role checks for most use cases while enabling fine-grained control when needed.
