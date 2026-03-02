# frozen_string_literal: true

module Scimitar
  module ComplexTypes
    module Rbac
      # Represents a structured entitlement (permission) assignment.
      # Replaces the "freestyle" entitlement notation in SCIM core (RFC 7643)
      # with a proper reference to an Entitlement resource.
      class EntitlementAssignment < Scimitar::ComplexTypes::Base
        set_schema Scimitar::Schema::Rbac::EntitlementAssignment
      end
    end
  end
end
