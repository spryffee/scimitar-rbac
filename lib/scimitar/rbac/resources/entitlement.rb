# frozen_string_literal: true

module Scimitar
  module Resources
    module Rbac
      # SCIM Resource class for the RBAC Entitlement (permission).
      class Entitlement < Scimitar::Resources::Base
        set_schema Scimitar::Schema::Rbac::Entitlement

        def self.endpoint
          "/Entitlements"
        end
      end
    end
  end
end
