# frozen_string_literal: true

module Scimitar
  module Schema
    module Rbac
      # Schema for the ApplicationReference complex type.
      # Defines sub-attributes for references to Application resources.
      class ApplicationReference < Scimitar::Schema::Base
        def self.scim_attributes
          @scim_attributes ||= [
            Scimitar::Schema::Attribute.new(name: "value",   type: "string", required: true),
            Scimitar::Schema::Attribute.new(name: "display", type: "string", mutability: "readOnly"),
          ]
        end
      end
    end
  end
end
