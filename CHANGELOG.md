# Changelog

All notable changes to this project are documented in this file.

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
