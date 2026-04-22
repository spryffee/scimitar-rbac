# frozen_string_literal: true

RSpec.describe Scimitar::Schema::Rbac::Role do
  subject(:schema) { described_class.new }

  describe "schema identity" do
    it "has the correct URN ID" do
      expect(described_class.id).to eq("urn:ietf:params:scim:schemas:extension:rbac:2.0:Role")
    end

    it "has a descriptive name" do
      expect(schema.name).to eq("Role")
    end

    it "has a description" do
      expect(schema.description).to include("RBAC Role")
    end
  end

  describe "schema attributes" do
    let(:attributes) { described_class.scim_attributes }
    let(:attr_names) { attributes.map(&:name) }

    it "defines displayName as required" do
      display_name = attributes.find { |a| a.name == "displayName" }
      expect(display_name).not_to be_nil
      expect(display_name.required).to be true
      expect(display_name.type).to eq("string")
    end

    it "defines type attribute" do
      expect(attr_names).to include("type")
    end

    it "defines description attribute" do
      expect(attr_names).to include("description")
    end

    it "defines entitlements as multi-valued (the key RBAC link)" do
      entitlements = attributes.find { |a| a.name == "entitlements" }
      expect(entitlements).not_to be_nil
      expect(entitlements.multiValued).to be true
    end

    it "defines parentRoles for hierarchy" do
      parent = attributes.find { |a| a.name == "parentRoles" }
      expect(parent).not_to be_nil
      expect(parent.multiValued).to be true
    end

    it "defines childRoles as read-only" do
      child = attributes.find { |a| a.name == "childRoles" }
      expect(child).not_to be_nil
      expect(child.multiValued).to be true
      expect(child.mutability).to eq("readOnly")
    end

    it "defines cardinality attributes" do
      expect(attr_names).to include("limitedAssignmentsPermitted")
      expect(attr_names).to include("totalAssignmentsPermitted")
      expect(attr_names).to include("totalAssignmentsUsed")
    end

    it "defines totalAssignmentsUsed as read-only" do
      total_used = attributes.find { |a| a.name == "totalAssignmentsUsed" }
      expect(total_used.mutability).to eq("readOnly")
    end
  end
end
