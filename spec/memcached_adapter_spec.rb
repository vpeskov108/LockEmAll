require "spec_helper"

class FakeModel
  include LockEmAll::MemcachedAdapter
end

# rubocop:disable Metrics/BlockLength
RSpec.describe LockEmAll::MemcachedAdapter do
  before do
    # LockEmAll.configuration({ adapter: :memcached })
    Test::MemcachedAdapter.create(object_name: "Article", object_key: "Library-programming", object_value: 1)
    Test::MemcachedAdapter.create(object_name: "Dictionary", object_key: "Library-programming", object_value: 2)
    Test::MemcachedAdapter.create(object_name: "Dictionary", object_key: "YouTube-dev-channel", object_value: 3)
  end

  describe "#get" do
    context "when locked objects not exists" do
      let(:fake_model_namespace) do
        FactoryBot.build(:fake_model,
                         object_name: "No-name-exists", object_key: "Library-programming", object_value: 10)
      end
      let(:fake_model_key) do
        FactoryBot.build(:fake_model,
                         object_name: "Dictionary", object_key: "No-key-exists", object_value: 3)
      end

      it "returns nil if object_name not found" do
        expect(fake_model_namespace.get).to be_nil
      end

      it "returns nil if object_key not found" do
        expect(fake_model_key.get).to be_nil
      end
    end

    context "when locked objects exists" do
      let(:fake_model_user) do
        FactoryBot.build(:fake_model,
                         object_name: "Article", object_key: "Library-programming", object_value: 1)
      end

      let(:fake_model_key) do
        FactoryBot.build(:fake_model,
                         object_name: "Dictionary", object_key: "YouTube-dev-channel", object_value: 3)
      end

      it "returns object_value = 1 if user within locked objects is found" do
        expect(fake_model_user.get).to eq(1)
      end

      it "returns object_value = 3 if object_key is found" do
        expect(fake_model_key.get).to eq(3)
      end
    end
  end

  describe "#create" do
    let(:fake_model) do
      FactoryBot.build(:fake_model,
                       object_name: "New-name", object_key: "New-key", object_value: 5)
    end

    it "returns object id if created new object" do
      expect(fake_model.create).to be_a(Numeric)
      expect(fake_model.get).to eq(5)
    end

    it "returns false if created exists object" do
      fake_model.create
      expect(fake_model.create).to be_falsey
    end
  end

  describe "#update" do
    let(:fake_model) do
      FactoryBot.build(:fake_model,
                       object_name: "Article", object_key: "Library-devopsing", object_value: 10)
    end
    let(:fake_model_update) do
      FactoryBot.build(:fake_model,
                       object_name: "Article", object_key: "Library-devopsing", object_value: 20)
    end

    it "returns updated value after update object" do
      fake_model.create
      expect(fake_model.get).to eq(10)

      fake_model_update.update
      expect(fake_model.get).to eq(20)
    end

    it "returns object id if updated exists object" do
      fake_model.create
      expect(fake_model.update).to be_a(Numeric)
    end
  end

  describe "#delete" do
    let(:fake_model) do
      FactoryBot.build(:fake_model,
                       object_name: "Article", object_key: "Library-programming", object_value: 1)
    end

    it "returns object id if deleted exists object" do
      expect(fake_model.delete).to be_truthy
    end

    it "returns false if deleted non exists object" do
      fake_model.delete
      expect(fake_model.delete).to be_falsey
    end
  end

  after do
    Test::MemcachedAdapter.delete(object_name: "Article", object_key: "Library-programming")
    Test::MemcachedAdapter.delete(object_name: "Dictionary", object_key: "Library-programming")
    Test::MemcachedAdapter.delete(object_name: "Dictionary", object_key: "YouTube-dev-channel")
    Test::MemcachedAdapter.delete(object_name: "Article", object_key: "Library-devopsing")
    Test::MemcachedAdapter.delete(object_name: "New-name", object_key: "New-key")
  end
  # rubocop:enable Metrics/BlockLength
end
