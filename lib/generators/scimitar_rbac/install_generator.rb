# frozen_string_literal: true

require "rails/generators"
require "rails/generators/active_record"

module ScimitarRbac
  # Generates migrations, models, and controllers for RBAC SCIM resources.
  #
  # Usage:
  #   rails generate scimitar_rbac:install
  #
  class InstallGenerator < Rails::Generators::Base
    include ActiveRecord::Generators::Migration

    source_root File.expand_path("templates", __dir__)

    desc "Creates migrations, models, and controllers for SCIM RBAC resources (Role, Entitlement, Application)."

    def create_migration_file
      migration_template "migration.rb.erb", "db/migrate/create_scimitar_rbac_tables.rb"
    end

    def create_model_files
      template "role_model.rb.erb",                "app/models/rbac_role.rb"
      template "entitlement_model.rb.erb",         "app/models/rbac_entitlement.rb"
      template "application_model.rb.erb",         "app/models/rbac_application.rb"
      template "role_hierarchy_model.rb.erb",      "app/models/rbac_role_hierarchy.rb"
      template "entitlement_hierarchy_model.rb.erb", "app/models/rbac_entitlement_hierarchy.rb"
    end

    def create_controller_files
      template "roles_controller.rb.erb",        "app/controllers/scim_v2/roles_controller.rb"
      template "entitlements_controller.rb.erb",  "app/controllers/scim_v2/entitlements_controller.rb"
      template "applications_controller.rb.erb",  "app/controllers/scim_v2/applications_controller.rb"
    end

    def display_post_install_message
      say ""
      say "SCIM RBAC resources have been generated!", :green
      say ""
      say "Next steps:"
      say "  1. Run migrations:  rails db:migrate"
      say "  2. Add routes to config/routes.rb:"
      say ""
      say "     namespace :scim_v2, path: 'scim/v2' do"
      say "       mount Scimitar::Engine, at: '/'"
      say "       Scimitar::Rbac::RouteHelper.mount_rbac_routes(self,"
      say "         roles_controller:        'scim_v2/roles',"
      say "         entitlements_controller: 'scim_v2/entitlements',"
      say "         applications_controller: 'scim_v2/applications'"
      say "       )"
      say "     end"
      say ""
    end

    private

    def migration_version
      "[#{ActiveRecord::Migration.current_version}]"
    end
  end
end
