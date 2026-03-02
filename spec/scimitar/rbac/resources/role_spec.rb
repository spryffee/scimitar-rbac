# frozen_string_literal: true

RSpec.describe Scimitar::Resources::Rbac::Role do
  describe "resource configuration" do
    it "uses the Role schema" do
      expect(described_class.schema).to eq(Scimitar::Schema::Rbac::Role)
    end

    it "has the /Roles endpoint" do
      expect(described_class.endpoint).to eq("/Roles")
    end

    it "has resource_type_id 'Role'" do
      expect(described_class.resource_type_id).to eq("Role")
    end
  end

  describe "resource instantiation" do
    it "can be instantiated with displayName" do
      role = described_class.new(displayName: "Administrator")
      expect(role.displayName).to eq("Administrator")
    end

    it "can be instantiated with all core attributes" do
      role = described_class.new(
        displayName: "Manager",
        type:        "business",
        description: "A management role"
      )
      expect(role.displayName).to eq("Manager")
      expect(role.type).to eq("business")
      expect(role.description).to eq("A management role")
    end

    it "supports cardinality attributes" do
      role = described_class.new(
        displayName: "Limited Role",
        limitedAssignmentsPermitted: 10,
        totalAssignmentsPermitted: 50
      )
      expect(role.limitedAssignmentsPermitted).to eq(10)
      expect(role.totalAssignmentsPermitted).to eq(50)
    end
  end

  describe "JSON serialization" do
    it "includes the schema URN in serialized output" do
      role = described_class.new(displayName: "Test Role")
      json = role.as_json

      expect(json["schemas"]).to include(Scimitar::Schema::Rbac::Role.id)
    end

    it "serializes core attributes" do
      role = described_class.new(
        displayName: "Admin",
        type:        "it",
        description: "IT administrator role"
      )
      json = role.as_json

      expect(json["displayName"]).to eq("Admin")
      expect(json["type"]).to eq("it")
      expect(json["description"]).to eq("IT administrator role")
    end
  end

  describe "resource_type" do
    it "generates a valid ResourceType" do
      rt = described_class.resource_type("https://example.com/scim/v2/ResourceTypes/Role")
      expect(rt).to be_a(Scimitar::ResourceType)
    end
  end
end
