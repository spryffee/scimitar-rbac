# frozen_string_literal: true

module Scimitar
  module Resources
    module Rbac
      # SCIM Resource class for the RBAC Application (target system / SP).
      class Application < Scimitar::Resources::Base
        set_schema Scimitar::Schema::Rbac::Application

        def self.endpoint
          "/Applications"
        end
      end
    end
  end
end
