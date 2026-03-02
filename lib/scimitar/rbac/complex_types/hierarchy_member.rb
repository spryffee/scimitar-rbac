# frozen_string_literal: true

module Scimitar
  module ComplexTypes
    module Rbac
      # Represents a reference to a parent or child in a role/entitlement
      # hierarchy. Used for parentRoles, childRoles, parentEntitlements,
      # and childEntitlements multi-valued attributes.
      #
      # Based on the RBAC data model from Baumer et al. (2023), which defines
      # many-to-many hierarchies RH for roles and entitlements.
      class HierarchyMember < Scimitar::ComplexTypes::Base
        set_schema Scimitar::Schema::Rbac::HierarchyMember
      end
    end
  end
end
