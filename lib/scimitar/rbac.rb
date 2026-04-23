# frozen_string_literal: true

require "scimitar"

require_relative "rbac/version"
require_relative "rbac/route_helper"

module Scimitar
  module Rbac
    # URN prefix for RBAC extension schemas
    URN_PREFIX = "urn:ietf:params:scim:schemas:extension:rbac:2.0"

    # Eagerly load all RBAC components. Called after Rails and scimitar
    # are fully initialized (via Engine initializer or manually).
    def self.load!
      return if @loaded

      # Complex-type schema classes must be loaded before the complex-type
      # classes that reference them (via set_schema), which in turn must be
      # loaded before the resource schema classes that embed them as attributes.
      require_relative "rbac/schema/hierarchy_member"
      require_relative "rbac/schema/role_assignment"
      require_relative "rbac/schema/entitlement_assignment"
      require_relative "rbac/schema/application_reference"

      # Complex types (must be loaded before resource schemas that reference them)
      require_relative "rbac/complex_types/hierarchy_member"
      require_relative "rbac/complex_types/role_assignment"
      require_relative "rbac/complex_types/entitlement_assignment"
      require_relative "rbac/complex_types/application_reference"

      # Resource schemas
      require_relative "rbac/schema/role"
      require_relative "rbac/schema/entitlement"
      require_relative "rbac/schema/application"

      # Resources
      require_relative "rbac/resources/role"
      require_relative "rbac/resources/entitlement"
      require_relative "rbac/resources/application"

      @loaded = true
    end

    # Register all RBAC resources with the Scimitar engine.
    # Called automatically by the Rails engine, or can be called manually.
    def self.register_resources!
      load!

      # Guard by endpoint string rather than class identity so the check
      # is stable across dev-mode code reloads (gem classes don't reload,
      # but endpoints are plain strings that always compare equal).
      registered_endpoints = Scimitar::Engine.custom_resources.map(&:endpoint)

      [
        Scimitar::Resources::Rbac::Role,
        Scimitar::Resources::Rbac::Entitlement,
        Scimitar::Resources::Rbac::Application
      ].each do |resource|
        unless registered_endpoints.include?(resource.endpoint)
          Scimitar::Engine.add_custom_resource(resource)
        end
      end
    end

    # Reset load state — useful for testing
    # @api private
    def self.reset!
      @loaded = false
    end
  end
end

# Auto-load Engine for Rails integration
require_relative "rbac/engine" if defined?(Rails::Engine)
