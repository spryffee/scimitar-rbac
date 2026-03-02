# frozen_string_literal: true

module Scimitar
  module ComplexTypes
    module Rbac
      # Represents a reference to an Application resource.
      # Used in Entitlement and Account resources to link back
      # to the target application/service provider.
      class ApplicationReference < Scimitar::ComplexTypes::Base
        set_schema Scimitar::Schema::Rbac::ApplicationReference
      end
    end
  end
end
