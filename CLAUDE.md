# scimitar-rbac — project instructions

## Brain wiki
This project is tracked in `~/brain/wiki/entities/scimitar-rbac.md`.
Follow the coding-session update workflow in `~/brain/CLAUDE.md` automatically — update the entity page when bugs are fixed, features are added, or a new version is released. Do not wait to be asked.

## Stack
Ruby gem · Rails engine · RSpec (dummy app in `spec/apps/dummy/`) · vendored bundle

## Key conventions
- Version in `lib/scimitar/rbac/version.rb`. Bump + CHANGELOG + git tag + `gem build` + GH release for every release.
- Always run `bundle exec rspec` before committing. All examples must pass.
- Generator templates live in `lib/generators/scimitar_rbac/templates/`. The install generator outputs migrations, models (including hierarchy models), and controllers.
- Engine uses `after_initialize` (not `to_prepare`) for resource registration. Guard by endpoint string, not class identity.
- Migration template must handle PostgreSQL (UUID PKs, pgcrypto) and SQLite/MySQL (string PKs). MySQL has no partial indexes — branch on `mysql` variable.
