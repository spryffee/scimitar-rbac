# frozen_string_literal: true

module Scimitar
  module Resources
    module Rbac
      # SCIM Resource class for the RBAC Role.
      class Role < Scimitar::Resources::Base
        set_schema Scimitar::Schema::Rbac::Role

        def self.endpoint
          "/Roles"
        end
      end
    end
  end
end
