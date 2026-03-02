# frozen_string_literal: true

# Boot the dummy Rails app (which loads scimitar + our gem)
ENV["RAILS_ENV"] ||= "test"
require File.expand_path("apps/dummy/config/environment", __dir__)

# Eagerly load RBAC components for testing (normally done by Engine initializer)
Scimitar::Rbac.register_resources!

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.order = :random
  Kernel.srand config.seed
end
