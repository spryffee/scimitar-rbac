# TODO

Deferred items surfaced during the 2026-04-22 bug audit. The critical
issues were shipped in [0.1.2](CHANGELOG.md). Everything below is either
a correctness latent, a polish issue, or an API tightening that can wait
for a future minor version.

## Medium

### Prevent self-loops and cycles in role / entitlement hierarchies

The composite unique index on `[parent_id, child_id]` stops duplicate
pairs but does not stop `parent == child`, and does nothing against
cycles like `A → B → A`. Anything that walks the graph recursively
(authorization resolution, admin UI) can infinite-loop.

Add a DB `CHECK` constraint `parent_role_id <> child_role_id` (and the
entitlement-hierarchy equivalent) in the generated migration, plus a
`validate :no_hierarchy_cycle` in the host-facing hierarchy models. Full
cycle detection is O(V+E) BFS from the new parent — not free but
correct.

Affected files:
- `lib/generators/scimitar_rbac/templates/migration.rb.erb`
- (new) `lib/generators/scimitar_rbac/templates/role_hierarchy_model.rb.erb` and entitlement equivalent, or extend the existing model templates.

### Index and constrain `external_id`

`external_id` columns are exposed through `scim_queryable_attributes`
but have no index and no uniqueness guarantee, so `GET /Roles?filter=externalId
eq "X"` is a full table scan and duplicate `externalId`s are allowed
across the same resource type. SCIM generally treats `externalId` as
client-unique per resource type.

Add per-table `add_index … :external_id, unique: true, where: "external_id IS NOT NULL"`
(or the DB-appropriate equivalent for partial uniqueness with NULLs).

Affected file:
- `lib/generators/scimitar_rbac/templates/migration.rb.erb`

### Make engine registration reload-safe

`Scimitar::Rbac::Engine` registers custom resources inside
`to_prepare`, which fires on every dev-mode reload. The current guard
via `Scimitar::Engine.custom_resources.include?(resource)` is an
`object_id` comparison and works today because scimitar gem code isn't
reloaded, but it's fragile. Move registration into `after_initialize`
(fires once) and/or make the include-check key off schema URN rather
than class identity.

Affected file:
- `lib/scimitar/rbac/engine.rb`

### Reject unknown keys in `RouteHelper.mount_rbac_routes`

Silently ignores typos like `roles_conroller:`. Should raise
`ArgumentError` on unknown keys, or at minimum require all three
explicit controller names.

Affected file:
- `lib/scimitar/rbac/route_helper.rb`

### Post-install message omits the Scimitar engine mount

The snippet printed after `rails g scimitar_rbac:install` shows only
the RBAC route helper but not `mount Scimitar::Engine, at: "/"`, which
is required for `/Schemas` and `/ResourceTypes` discovery. Expand the
message, or link to the README section.

Affected file:
- `lib/generators/scimitar_rbac/install_generator.rb` (`display_post_install_message`)

## Minor

### Schema `initialize(options = {})` takes an ignored parameter

All four schema classes accept an `options` hash and pass hardcoded
values to `super`. Either remove the parameter or thread it through
with `super(**options.reverse_merge(...))`. Cosmetic but misleading.

Affected files:
- `lib/scimitar/rbac/schema/role.rb`
- `lib/scimitar/rbac/schema/entitlement.rb`
- `lib/scimitar/rbac/schema/application.rb`

### `Entitlement.application` attribute has no explicit mutability

Defaults to `readWrite`. Probably correct in practice, but most SCIM
schemas state mutability explicitly to avoid ambiguity for clients.

Affected file:
- `lib/scimitar/rbac/schema/entitlement.rb`

### No scaffold for User ↔ Role (UA) assignment

The gem bills itself as an NIST-RBAC profile but ships nothing for
UA. Either scaffold a join model + migration (and optionally expose
`users` on the Role schema again once real data can populate it) or
document clearly that modeling UA is the host app's responsibility.

Affected files:
- README
- (new) generator templates for a UA join model and migration

### Generated controllers have no default order

`roles_controller.rb.erb` etc. use `Model.all` as the storage scope.
SCIM list responses are paginated; without a stable `.order(:id)` the
window between `startIndex=1` and `startIndex=11` isn't guaranteed to
be consistent. Confirm what scimitar's `ActiveRecordBackedResourcesController`
does by default; if it doesn't inject an order, set `.order(:id)` in
the generator template.

Affected files:
- `lib/generators/scimitar_rbac/templates/roles_controller.rb.erb`
- `lib/generators/scimitar_rbac/templates/entitlements_controller.rb.erb`
- `lib/generators/scimitar_rbac/templates/applications_controller.rb.erb`

### Hardcoded class names in generated model templates

Model templates reference `"RbacRoleHierarchy"` and
`"RbacEntitlementHierarchy"` by string. If the generator ever accepts
model-name arguments, these will silently break. Low urgency — the
generator has no such arguments today.

Affected files:
- `lib/generators/scimitar_rbac/templates/role_model.rb.erb`
- `lib/generators/scimitar_rbac/templates/entitlement_model.rb.erb`

### Dead `Scimitar::Rbac::Error` class

Defined at `lib/scimitar/rbac.rb:10`, never raised. Fine as public API
reservation, but remove if it doesn't have a real use case by the
next minor release.

### Committed `.gem` build artifacts

`scimitar-rbac-0.1.0.gem`, `scimitar-rbac-0.1.1.gem` live at the repo
root. Usually gitignored. Harmless but noisy.

### Comment wording in `lib/scimitar/rbac.rb`

The load-order comment says complex-type *schemas* must be loaded
before "the complex types that reference them and before resource
schemas that use them" — the second half is slightly inaccurate.
Complex-type schemas are referenced by complex-type classes (via
`set_schema`), not by resource schemas directly. Minor.
