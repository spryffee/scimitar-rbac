# frozen_string_literal: true

module Scimitar
  module Rbac
    # Provides a convenience method for mounting RBAC SCIM resource routes
    # in a Rails application's routes.rb.
    #
    # Usage:
    #
    #   # config/routes.rb
    #   Rails.application.routes.draw do
    #     namespace :scim_v2, path: "scim/v2" do
    #       mount Scimitar::Engine, at: "/"
    #
    #       # Mount standard SCIM resources (Users, Groups) manually...
    #
    #       # Mount all RBAC resources at once:
    #       Scimitar::Rbac::RouteHelper.mount_rbac_routes(self,
    #         roles_controller:        "scim_v2/roles",
    #         entitlements_controller: "scim_v2/entitlements",
    #         applications_controller: "scim_v2/applications"
    #       )
    #     end
    #   end
    #
    module RouteHelper
      # Mount CRUD routes for all RBAC resources.
      #
      # @param router [ActionDispatch::Routing::RouteSet] The router (pass `self` from routes.rb)
      # @param options [Hash] Controller names for each resource
      # @option options [String] :roles_controller Controller for Roles (e.g., "scim_v2/roles")
      # @option options [String] :entitlements_controller Controller for Entitlements
      # @option options [String] :applications_controller Controller for Applications
      def self.mount_rbac_routes(router, **options)
        if options[:roles_controller]
          mount_resource_routes(router, "Roles", options[:roles_controller])
        end

        if options[:entitlements_controller]
          mount_resource_routes(router, "Entitlements", options[:entitlements_controller])
        end

        if options[:applications_controller]
          mount_resource_routes(router, "Applications", options[:applications_controller])
        end
      end

      # Mount standard SCIM CRUD routes for a single resource.
      #
      # @param router [ActionDispatch::Routing::RouteSet] The router
      # @param resource_name [String] The SCIM resource path (e.g., "Roles")
      # @param controller [String] The controller name (e.g., "scim_v2/roles")
      def self.mount_resource_routes(router, resource_name, controller)
        router.instance_exec do
          get    resource_name,            to: "#{controller}#index"
          get    "#{resource_name}/:id",   to: "#{controller}#show"
          post   resource_name,            to: "#{controller}#create"
          put    "#{resource_name}/:id",   to: "#{controller}#replace"
          patch  "#{resource_name}/:id",   to: "#{controller}#update"
          delete "#{resource_name}/:id",   to: "#{controller}#destroy"
        end
      end
    end
  end
end
