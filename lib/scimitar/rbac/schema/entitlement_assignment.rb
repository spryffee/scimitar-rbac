# frozen_string_literal: true

module Scimitar
  module Schema
    module Rbac
      # Schema for the EntitlementAssignment complex type.
      # Replaces the "freestyle" entitlement notation in SCIM core (RFC 7643)
      # with structured sub-attributes referencing an Entitlement resource.
      class EntitlementAssignment < Scimitar::Schema::Base
        def self.scim_attributes
          @scim_attributes ||= [
            Scimitar::Schema::Attribute.new(name: "value",   type: "string", required: true),
            Scimitar::Schema::Attribute.new(name: "display", type: "string", mutability: "readOnly"),
            Scimitar::Schema::Attribute.new(name: "type",    type: "string"),
          ]
        end
      end
    end
  end
end
