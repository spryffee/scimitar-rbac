# frozen_string_literal: true

module Scimitar
  module Rbac
    class Engine < ::Rails::Engine
      # Use after_initialize (fires once at boot, not on every dev reload)
      # so resource registration is idempotent and class-identity stable.
      initializer "scimitar_rbac.register_resources" do |app|
        app.config.after_initialize do
          Scimitar::Rbac.register_resources!
        end
      end
    end
  end
end
