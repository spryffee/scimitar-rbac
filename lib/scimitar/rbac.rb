# frozen_string_literal: true

require "scimitar"

require_relative "rbac/version"
require_relative "rbac/route_helper"

module Scimitar
  module Rbac
    class Error < StandardError; end

    # URN prefix for RBAC extension schemas
    URN_PREFIX = "urn:ietf:params:scim:schemas:extension:rbac:2.0"

    # Eagerly load all RBAC components. Called after Rails and scimitar
    # are fully initialized (via Engine initializer or manually).
    def self.load!
      return if @loaded

      # Complex type schemas (must be loaded before the complex types
      # that reference them and before resource schemas that use them)
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

      [
        Scimitar::Resources::Rbac::Role,
        Scimitar::Resources::Rbac::Entitlement,
        Scimitar::Resources::Rbac::Application
      ].each do |resource|
        unless Scimitar::Engine.custom_resources.include?(resource)
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
