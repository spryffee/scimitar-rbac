# frozen_string_literal: true

RSpec.describe Scimitar::Rbac do
  it "has a version number" do
    expect(Scimitar::Rbac::VERSION).not_to be_nil
    expect(Scimitar::Rbac::VERSION).to match(/\A\d+\.\d+\.\d+\z/)
  end

  it "defines a URN prefix" do
    expect(Scimitar::Rbac::URN_PREFIX).to eq("urn:ietf:params:scim:schemas:extension:rbac:2.0")
  end

  describe ".register_resources!" do
    it "registers all RBAC resources with Scimitar engine" do
      # Reset custom resources to avoid pollution
      initial_count = Scimitar::Engine.custom_resources.length

      Scimitar::Rbac.register_resources!

      custom = Scimitar::Engine.custom_resources
      expect(custom).to include(Scimitar::Resources::Rbac::Role)
      expect(custom).to include(Scimitar::Resources::Rbac::Entitlement)
      expect(custom).to include(Scimitar::Resources::Rbac::Application)
    end

    it "does not raise when called multiple times" do
      expect { 2.times { Scimitar::Rbac.register_resources! } }.not_to raise_error
    end
  end
end
