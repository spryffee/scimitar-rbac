# Changelog

All notable changes to this project are documented in this file.

## [0.1.3] - 2026-04-23

### Fixed

- **Engine registration is now reload-safe.** The initializer previously used
  `config.to_prepare`, which fires on every dev-mode code reload. It now uses
  `config.after_initialize`, which fires once at boot. The duplicate-registration
  guard was also changed from object-identity (`include?`) to endpoint-string
  comparison, making it robust even if called multiple times.

- **Schema `initialize` no longer accepts an unused `options` parameter.**
  `Scimitar::Schema::Rbac::Role`, `Entitlement`, and `Application` all had
  `def initialize(options = {})` that silently ignored the argument and passed
  hardcoded values to `super`. The parameter has been removed.

- **Hierarchy self-loops are now rejected at the DB level.** The generated
  migration includes `CHECK` constraints (`parent_role_id <> child_role_id` and
  `parent_entitlement_id <> child_entitlement_id`) so the database enforces
  the invariant independent of the application.

### Added

- **Hierarchy model scaffolding with cycle detection.** The generator now
  produces `RbacRoleHierarchy` and `RbacEntitlementHierarchy` model files.
  Both include `validate :no_self_loop` and `validate :no_cycle` (O(V+E) BFS
  from the proposed child node) so full graph cycles are caught before the
  record is persisted.

- **Partial unique indexes on `external_id`.** The generated migration now adds
  `WHERE external_id IS NOT NULL` partial unique indexes on all three resource
  tables (PostgreSQL / SQLite). MySQL/MariaDB, which doesn't support partial
  indexes, gets a plain index instead.

- **`external_id` is now indexed.** Queries that filter by `externalId` (SCIM's
  standard client-supplied identifier) were previously full-table scans.

### Changed

- **`RouteHelper.mount_rbac_routes` now raises `ArgumentError` on unknown option
  keys.** Typos like `roles_conroller:` previously silenced without warning.

- **`Entitlement.application` schema attribute now declares `mutability:
  "readWrite"` explicitly.** The value was always `readWrite` by default, but
  explicit is better than implicit for schema discovery.

- **Removed the dead `Scimitar::Rbac::Error` class.** It was defined but never
  raised anywhere in the codebase.

- **Fixed comment wording in `lib/scimitar/rbac.rb`.** The load-order comment
  now accurately describes that complex-type schema classes are referenced by
  complex-type classes (via `set_schema`), not by resource schema classes
  directly.

- **Stale `.gem` build artifacts removed from the working tree.**
  `scimitar-rbac-0.1.0.gem` and `scimitar-rbac-0.1.1.gem` were left at the
  repo root after prior releases. They were already gitignored but cluttered
  the directory.

## [0.1.2] - 2026-04-22

### Fixed

- **Migration template is now adapter-neutral.** The generated
  `CreateScimitarRbacTables` migration previously assumed PostgreSQL (enabled
  `pgcrypto` unconditionally and used `uuid` column types), which broke
  `rails db:migrate` on SQLite and MySQL. The migration now detects the
  adapter at run time: PostgreSQL still gets native `uuid` primary keys and
  foreign keys, while other adapters fall back to `string` columns that hold
  application-generated UUIDs.

- **Removed the `users` attribute from the Role schema.** The attribute was
  advertised as a multi-valued, read-only list of users holding the role, but
  neither the gem nor its generator template provided any mechanism to
  populate it — the User↔Role (UA) relationship is the host application's
  responsibility and the generator ships no UA scaffolding. Leaving it in
  the schema caused `GET /Roles/:id` to advertise an attribute that was
  always empty or absent. Host apps that model UA can expose role
  membership through their own schema extension.

## [0.1.1] - 2026-03-24

- Lock `scimitar` dependency to `~> 2.15`.

## [0.1.0] - 2026-03-20

- Initial release: Role, Entitlement, and Application SCIM resource types
  for the RBAC profile, generator for migrations/models/controllers, and
  route helper for mounting RBAC CRUD endpoints.
