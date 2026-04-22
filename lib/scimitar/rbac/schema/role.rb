# frozen_string_literal: true

module Scimitar
  module Schema
    module Rbac
      # SCIM schema for the Role resource as defined in the RBAC profile
      # for SCIM (Baumer et al., 2023).
      #
      # Roles are the central RBAC entity, serving as an intermediate between
      # Users and Entitlements (permissions). The schema supports:
      #
      # - Core RBAC: User <-> Role <-> Entitlement assignments
      # - Hierarchical RBAC: Role hierarchies via parentRoles/childRoles
      # - Constrained RBAC: Cardinality constraints on assignments
      class Role < Scimitar::Schema::Base
        def initialize(options = {})
          super(
            name:            "Role",
            id:              self.class.id,
            description:     "Represents an RBAC Role — an intermediate entity between Users and Entitlements (permissions).",
            scim_attributes: self.class.scim_attributes
          )
        end

        def self.id
          "urn:ietf:params:scim:schemas:extension:rbac:2.0:Role"
        end

        def self.scim_attributes
          @scim_attributes ||= [
            Scimitar::Schema::Attribute.new(name: "displayName", type: "string", required: true),
            Scimitar::Schema::Attribute.new(name: "type",        type: "string"),
            Scimitar::Schema::Attribute.new(name: "description", type: "string"),

            Scimitar::Schema::Attribute.new(name: "entitlements", multiValued: true,
              complexType: Scimitar::ComplexTypes::Rbac::EntitlementAssignment),

            Scimitar::Schema::Attribute.new(name: "parentRoles",  multiValued: true,
              complexType: Scimitar::ComplexTypes::Rbac::HierarchyMember),

            Scimitar::Schema::Attribute.new(name: "childRoles",   multiValued: true,
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
