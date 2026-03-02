# frozen_string_literal: true

require_relative "lib/scimitar/rbac/version"

Gem::Specification.new do |spec|
  spec.name = "scimitar-rbac"
  spec.version = Scimitar::Rbac::VERSION
  spec.authors = ["Ahmed Gasanov"]
  spec.email = ["spryffee@gmail.com"]

  spec.summary = "RBAC profile for SCIM, built on top of the scimitar gem."
  spec.description = <<~DESC
    Extends the scimitar gem with Role-Based Access Control (RBAC) resources
    for SCIM v2, based on the NIST RBAC standard and the Baumer et al. research
    paper "SCIM: Survey and Enhancement With RBAC" (IEEE Access, 2023).
    Provides Role, Entitlement, and Application SCIM resource types with full
    schema definitions, enabling standardized RBAC data exchange via SCIM.
  DESC
  spec.homepage = "https://github.com/spryffee/scimitar-rbac"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/spryffee/scimitar-rbac"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/])
    end
  end
  spec.require_paths = ["lib"]

  spec.add_dependency "scimitar", "~> 2.0"
  spec.add_dependency "rails", ">= 7.0"
end
