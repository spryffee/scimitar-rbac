# frozen_string_literal: true

RSpec.describe Scimitar::Schema::Rbac::Application do
  subject(:schema) { described_class.new }

  describe "schema identity" do
    it "has the correct URN ID" do
      expect(described_class.id).to eq("urn:ietf:params:scim:schemas:extension:rbac:2.0:Application")
    end

    it "has a descriptive name" do
      expect(schema.name).to eq("Application")
    end
  end

  describe "schema attributes" do
    let(:attributes) { described_class.scim_attributes }
    let(:attr_names) { attributes.map(&:name) }

    it "defines displayName as required" do
      display_name = attributes.find { |a| a.name == "displayName" }
      expect(display_name.required).to be true
    end

    it "defines description" do
      expect(attr_names).to include("description")
    end

    it "defines active boolean" do
      active = attributes.find { |a| a.name == "active" }
      expect(active.type).to eq("boolean")
    end

    it "defines entitlements as multi-valued read-only" do
      entitlements = attributes.find { |a| a.name == "entitlements" }
      expect(entitlements.multiValued).to be true
      expect(entitlements.mutability).to eq("readOnly")
    end
  end
end
