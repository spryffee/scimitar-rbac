# frozen_string_literal: true

RSpec.describe Scimitar::Resources::Rbac::Application do
  describe "resource configuration" do
    it "uses the Application schema" do
      expect(described_class.schema).to eq(Scimitar::Schema::Rbac::Application)
    end

    it "has the /Applications endpoint" do
      expect(described_class.endpoint).to eq("/Applications")
    end

    it "has resource_type_id 'Application'" do
      expect(described_class.resource_type_id).to eq("Application")
    end
  end

  describe "resource instantiation" do
    it "can be instantiated with displayName" do
      app = described_class.new(displayName: "Billing Service")
      expect(app.displayName).to eq("Billing Service")
    end

    it "supports active boolean" do
      app = described_class.new(displayName: "Test App", active: true)
      expect(app.active).to be true
    end
  end

  describe "JSON serialization" do
    it "includes the schema URN" do
      app = described_class.new(displayName: "Test")
      json = app.as_json
      expect(json["schemas"]).to include(Scimitar::Schema::Rbac::Application.id)
    end
  end
end
