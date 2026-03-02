# frozen_string_literal: true

RSpec.describe "RBAC Complex Types" do
  describe Scimitar::ComplexTypes::Rbac::HierarchyMember do
    it "defines value, display, and type sub-attributes" do
      schema = described_class.schema
      attr_names = schema.scim_attributes.map(&:name)

      expect(attr_names).to include("value")
      expect(attr_names).to include("display")
      expect(attr_names).to include("type")
    end

    it "marks value as required" do
      value_attr = described_class.schema.scim_attributes.find { |a| a.name == "value" }
      expect(value_attr.required).to be true
    end

    it "marks display as readOnly" do
      display_attr = described_class.schema.scim_attributes.find { |a| a.name == "display" }
      expect(display_attr.mutability).to eq("readOnly")
    end

    it "can be instantiated with attributes" do
      member = described_class.new(value: "abc-123", display: "Admin Role")
      expect(member.value).to eq("abc-123")
      expect(member.display).to eq("Admin Role")
    end
  end

  describe Scimitar::ComplexTypes::Rbac::RoleAssignment do
    it "defines value, display, and type sub-attributes" do
      attr_names = described_class.schema.scim_attributes.map(&:name)

      expect(attr_names).to include("value")
      expect(attr_names).to include("display")
      expect(attr_names).to include("type")
    end

    it "can be instantiated with attributes" do
      ra = described_class.new(value: "role-1", type: "business")
      expect(ra.value).to eq("role-1")
      expect(ra.type).to eq("business")
    end
  end

  describe Scimitar::ComplexTypes::Rbac::EntitlementAssignment do
    it "defines value, display, and type sub-attributes" do
      attr_names = described_class.schema.scim_attributes.map(&:name)

      expect(attr_names).to include("value")
      expect(attr_names).to include("display")
      expect(attr_names).to include("type")
    end

    it "can be instantiated with attributes" do
      ea = described_class.new(value: "ent-1", display: "Read Users")
      expect(ea.value).to eq("ent-1")
      expect(ea.display).to eq("Read Users")
    end
  end

  describe Scimitar::ComplexTypes::Rbac::ApplicationReference do
    it "defines value and display sub-attributes" do
      attr_names = described_class.schema.scim_attributes.map(&:name)

      expect(attr_names).to include("value")
      expect(attr_names).to include("display")
    end

    it "does not include type sub-attribute" do
      attr_names = described_class.schema.scim_attributes.map(&:name)
      expect(attr_names).not_to include("type")
    end

    it "can be instantiated with attributes" do
      ar = described_class.new(value: "app-1", display: "Billing Service")
      expect(ar.value).to eq("app-1")
      expect(ar.display).to eq("Billing Service")
    end
  end
end
