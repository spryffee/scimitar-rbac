# frozen_string_literal: true

module Scimitar
  module Schema
    module Rbac
      # SCIM schema for the Application resource.
      # Applications represent target systems / Service Providers (SPs).
      # Entitlements are application-specific (each belongs to one application).
      class Application < Scimitar::Schema::Base
        def initialize
          super(
            name:            "Application",
            id:              self.class.id,
            description:     "Represents a target application (service provider) in the RBAC model.",
            scim_attributes: self.class.scim_attributes
          )
        end

        def self.id
          "urn:ietf:params:scim:schemas:extension:rbac:2.0:Application"
        end

        def self.scim_attributes
          @scim_attributes ||= [
            Scimitar::Schema::Attribute.new(name: "displayName", type: "string", required: true),
            Scimitar::Schema::Attribute.new(name: "description", type: "string"),
            Scimitar::Schema::Attribute.new(name: "active",      type: "boolean"),

            Scimitar::Schema::Attribute.new(name: "entitlements", multiValued: true,
              complexType: Scimitar::ComplexTypes::Rbac::EntitlementAssignment, mutability: "readOnly"),
          ]
        end
      end
    end
  end
end
