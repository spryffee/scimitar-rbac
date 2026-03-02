# frozen_string_literal: true

module Scimitar
  module Rbac
    class Engine < ::Rails::Engine
      initializer "scimitar_rbac.register_resources" do
        Rails.application.config.to_prepare do
          Scimitar::Rbac.register_resources!
        end
      end
    end
  end
end
