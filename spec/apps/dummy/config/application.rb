# frozen_string_literal: true

require_relative "boot"

require "rails"
require "active_model/railtie"
require "action_controller/railtie"
require "action_view/railtie"

Bundler.require(*Rails.groups)

require "scimitar"
require "scimitar/rbac"

module Dummy
  class Application < Rails::Application
    config.load_defaults 7.0
    config.eager_load = false
    config.logger = Logger.new(nil) # silence logs during tests
    config.secret_key_base = "test-secret-key-base-for-scimitar-rbac-specs"
  end
end
