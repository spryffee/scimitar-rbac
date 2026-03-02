# frozen_string_literal: true

module Scimitar
  module ComplexTypes
    module Rbac
      # Represents a structured role assignment for a User or Account.
      # Replaces the "freestyle" role notation in SCIM core (RFC 7643)
      # with a proper reference to a Role resource.
      class RoleAssignment < Scimitar::ComplexTypes::Base
        set_schema Scimitar::Schema::Rbac::RoleAssignment
      end
    end
  end
end
