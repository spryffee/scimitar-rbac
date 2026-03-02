# frozen_string_literal: true

RSpec.describe Scimitar::Resources::Rbac::Entitlement do
  describe "resource configuration" do
    it "uses the Entitlement schema" do
      expect(described_class.schema).to eq(Scimitar::Schema::Rbac::Entitlement)
    end

    it "has the /Entitlements endpoint" do
      expect(described_class.endpoint).to eq("/Entitlements")
    end

    it "has resource_type_id 'Entitlement'" do
      expect(described_class.resource_type_id).to eq("Entitlement")
    end
  end

  describe "resource instantiation" do
    it "can be instantiated with displayName" do
      ent = described_class.new(displayName: "read:users")
      expect(ent.displayName).to eq("read:users")
    end

    it "supports type and description" do
      ent = described_class.new(
        displayName: "write:billing",
        type:        "api_scope",
        description: "Write access to billing API"
      )
      expect(ent.type).to eq("api_scope")
      expect(ent.description).to eq("Write access to billing API")
    end
  end

  describe "JSON serialization" do
    it "includes the schema URN" do
      ent = described_class.new(displayName: "Test")
      json = ent.as_json
      expect(json["schemas"]).to include(Scimitar::Schema::Rbac::Entitlement.id)
    end
  end
end
