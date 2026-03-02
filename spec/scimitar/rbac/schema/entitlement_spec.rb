# frozen_string_literal: true

RSpec.describe Scimitar::Schema::Rbac::Entitlement do
  subject(:schema) { described_class.new }

  describe "schema identity" do
    it "has the correct URN ID" do
      expect(described_class.id).to eq("urn:ietf:params:scim:schemas:extension:rbac:2.0:Entitlement")
    end

    it "has a descriptive name" do
      expect(schema.name).to eq("Entitlement")
    end
  end

  describe "schema attributes" do
    let(:attributes) { described_class.scim_attributes }
    let(:attr_names) { attributes.map(&:name) }

    it "defines displayName as required" do
      display_name = attributes.find { |a| a.name == "displayName" }
      expect(display_name).not_to be_nil
      expect(display_name.required).to be true
    end

    it "defines type and description" do
      expect(attr_names).to include("type")
      expect(attr_names).to include("description")
    end

    it "defines application reference" do
      app = attributes.find { |a| a.name == "application" }
      expect(app).not_to be_nil
    end

    it "defines roles as multi-valued read-only" do
      roles = attributes.find { |a| a.name == "roles" }
      expect(roles).not_to be_nil
      expect(roles.multiValued).to be true
      expect(roles.mutability).to eq("readOnly")
    end

    it "defines entitlement hierarchy attributes" do
      expect(attr_names).to include("parentEntitlements")
      expect(attr_names).to include("childEntitlements")
    end

    it "defines cardinality attributes" do
      expect(attr_names).to include("limitedAssignmentsPermitted")
      expect(attr_names).to include("totalAssignmentsPermitted")
      expect(attr_names).to include("totalAssignmentsUsed")
    end
  end
end
