# frozen_string_literal: true

module Scimitar
  module Schema
    module Rbac
      # Schema for the HierarchyMember complex type.
      # Defines the sub-attributes for role/entitlement hierarchy references.
      class HierarchyMember < Scimitar::Schema::Base
        def self.scim_attributes
          @scim_attributes ||= [
            Scimitar::Schema::Attribute.new(name: "value",   type: "string", required: true),
            Scimitar::Schema::Attribute.new(name: "display", type: "string", mutability: "readOnly"),
            Scimitar::Schema::Attribute.new(name: "type",    type: "string", mutability: "readOnly"),
          ]
        end
      end
    end
  end
end
