# scimitar-rbac

An RBAC (Role-Based Access Control) profile for SCIM v2, built as an extension to the [scimitar](https://github.com/RIPAGlobal/scimitar) gem.

Based on the research paper:

> **Baumer, T., Muller, M., & Pernul, G. (2023).** *System for Cross-Domain Identity Management (SCIM): Survey and Enhancement With RBAC.* IEEE Access, 11, 86872-86894. DOI: [10.1109/ACCESS.2023.3304270](https://doi.org/10.1109/ACCESS.2023.3304270)

## What This Gem Does

The SCIM RFC family (RFC 7642-7644) focuses on identity data (Users, Groups) but only loosely prepares for RBAC. The `roles` and `entitlements` attributes on the User resource are specified in a "freestyle" notation without independent endpoints or the critical Role-to-Entitlement relationship. This leads to vendor-specific implementations that break interoperability.

This gem solves this by adding three first-class SCIM resource types:

| Resource | Endpoint | URN Schema ID |
|----------|----------|---------------|
| **Role** | `/Roles` | `urn:ietf:params:scim:schemas:extension:rbac:2.0:Role` |
| **Entitlement** | `/Entitlements` | `urn:ietf:params:scim:schemas:extension:rbac:2.0:Entitlement` |
| **Application** | `/Applications` | `urn:ietf:params:scim:schemas:extension:rbac:2.0:Application` |

### RBAC Data Model

```
          0,n          0,n           0,n
  User ────── Role ────── Entitlement ────── Application
               │                │
           0,n │ RH         0,n │ EH
               │                │
              Role          Entitlement
          (hierarchy)      (hierarchy)
```

- **Role** — intermediate entity between Users and Entitlements (permissions)
- **Entitlement** — application-specific permission, belongs to one Application
- **Application** — target system / Service Provider

Key relationship: **Role ↔ Entitlement** (PA ⊆ P x R) — the assignment that standard SCIM lacks.

## Installation

Add to your Gemfile:

```ruby
gem "scimitar",      "~> 2.0"
gem "scimitar-rbac", "~> 0.1"
```

Then run:

```bash
bundle install
rails generate scimitar_rbac:install
rails db:migrate
```

## Configuration

### Routes

Add RBAC resource routes to your `config/routes.rb`:

```ruby
namespace :scim_v2, path: "scim/v2" do
  mount Scimitar::Engine, at: "/"

  # Standard SCIM resources
  get    "Users",     to: "scim_v2/users#index"
  get    "Users/:id", to: "scim_v2/users#show"
  post   "Users",     to: "scim_v2/users#create"
  # ...etc

  # RBAC resources (all at once)
  Scimitar::Rbac::RouteHelper.mount_rbac_routes(self,
    roles_controller:        "scim_v2/roles",
    entitlements_controller: "scim_v2/entitlements",
    applications_controller: "scim_v2/applications"
  )
end
```

### Models

The generator creates `RbacRole`, `RbacEntitlement`, and `RbacApplication` models with the `Scimitar::Resources::Mixin` already configured. Customize the attribute maps to match your domain.

### Controllers

The generator creates controllers inheriting from `Scimitar::ActiveRecordBackedResourcesController`. Override `storage_scope` to add custom filtering:

```ruby
class ScimV2::RolesController < Scimitar::ActiveRecordBackedResourcesController
  def storage_class
    RbacRole
  end

  def storage_scope
    RbacRole.where(active: true)
  end
end
```

## SCIM API Examples

### Create a Role

```http
POST /scim/v2/Roles
Content-Type: application/scim+json

{
  "schemas": ["urn:ietf:params:scim:schemas:extension:rbac:2.0:Role"],
  "displayName": "Billing Administrator",
  "type": "business",
  "description": "Full access to billing operations",
  "entitlements": [
    { "value": "ent-uuid-1" },
    { "value": "ent-uuid-2" }
  ]
}
```

### Create an Entitlement

```http
POST /scim/v2/Entitlements
Content-Type: application/scim+json

{
  "schemas": ["urn:ietf:params:scim:schemas:extension:rbac:2.0:Entitlement"],
  "displayName": "billing:write",
  "type": "api_scope",
  "application": { "value": "app-uuid-1" }
}
```

### Discover RBAC Resources

```http
GET /scim/v2/ResourceTypes
```

Returns Role, Entitlement, and Application alongside standard User and Group resource types.

## Design Principles

Following the paper's guidance, this gem balances three design principles:

1. **Validity** — implements the NIST RBAC standard (Ferraiolo et al., 2001) with proper User-Role-Entitlement relationships, hierarchies, and cardinality constraints
2. **Simplicity** — minimal overhead, reuses SCIM conventions, no unnecessary resources
3. **Flexibility** — extensible schemas, custom attributes via SCIM extension mechanism

## Future Extensions

The following resources from the full RBAC profile can be added in future versions:

- **Account** — user's identity within a specific application
- **SoD** (Separation of Duty) — constraints on mutually exclusive roles/entitlements
- **Session** — runtime activation of roles and entitlements

## References

- [RFC 7642](https://www.rfc-editor.org/info/rfc7642) — SCIM: Definitions, Overview, Concepts, and Requirements
- [RFC 7643](https://www.rfc-editor.org/info/rfc7643) — SCIM: Core Schema
- [RFC 7644](https://www.rfc-editor.org/info/rfc7644) — SCIM: Protocol
- [Zollner (2022)](https://datatracker.ietf.org/doc/draft-ietf-scim-roles-entitlements/) — SCIM Roles and Entitlements Extension
- [NIST RBAC](https://doi.org/10.1145/501978.501980) — Proposed NIST Standard for Role-Based Access Control
- [RBAC4SCIM Swagger](https://rbac4scim.github.io/api) — Reference API prototype from the paper

## License

MIT
