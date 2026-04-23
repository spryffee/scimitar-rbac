# frozen_string_literal: true

module Scimitar
  module Schema
    module Rbac
      # SCIM schema for the Entitlement (permission) resource.
      # Entitlements represent application-specific permissions, each belonging
      # to one Application. The Role<->Entitlement relationship is the key
      # missing link in standard SCIM that this profile addresses.
      class Entitlement < Scimitar::Schema::Base
        def initialize
          super(
            name:            "Entitlement",
            id:              self.class.id,
            description:     "Represents an RBAC Entitlement (permission) — an application-specific access right assignable to Roles.",
            scim_attributes: self.class.scim_attributes
          )
        end

        def self.id
          "urn:ietf:params:scim:schemas:extension:rbac:2.0:Entitlement"
        end

        def self.scim_attributes
          @scim_attributes ||= [
            Scimitar::Schema::Attribute.new(name: "displayName", type: "string", required: true),
            Scimitar::Schema::Attribute.new(name: "type",        type: "string"),
            Scimitar::Schema::Attribute.new(name: "description", type: "string"),

            Scimitar::Schema::Attribute.new(name: "application",
              complexType: Scimitar::ComplexTypes::Rbac::ApplicationReference, mutability: "readWrite"),

            Scimitar::Schema::Attribute.new(name: "roles", multiValued: true,
              complexType: Scimitar::ComplexTypes::Rbac::RoleAssignment, mutability: "readOnly"),

            Scimitar::Schema::Attribute.new(name: "parentEntitlements", multiValued: true,
              complexType: Scimitar::ComplexTypes::Rbac::HierarchyMember),

            Scimitar::Schema::Attribute.new(name: "childEntitlements",  multiValued: true,
              complexType: Scimitar::ComplexTypes::Rbac::HierarchyMember, mutability: "readOnly"),

            Scimitar::Schema::Attribute.new(name: "limitedAssignmentsPermitted", type: "integer"),
            Scimitar::Schema::Attribute.new(name: "totalAssignmentsPermitted",   type: "integer"),
            Scimitar::Schema::Attribute.new(name: "totalAssignmentsUsed",        type: "integer", mutability: "readOnly"),
          ]
        end
      end
    end
  end
end
