require "spec_helper"

RSpec.describe LockEmAll::LockObject do # rubocop:disable Metrics/BlockLength
  let!(:mock_adapter) { instance_double(LockEmAll::LockObject) }
  let(:lock_object_one) do
    FactoryBot.build(:lock_object,
                     object_params: { object_name: "Test", object_key: "Library-programming" }, user_id: 1)
  end
  let(:lock_object_two) do
    FactoryBot.build(:lock_object,
                     object_params: { object_name: "Test", object_key: "YouTube-dev-channel" }, user_id: 2)
  end

  before do
    allow(LockEmAll::NullAdapter).to receive(:new).and_return(mock_adapter)
    Test::MemcachedAdapter.create(object_name: "Test", object_key: "Library-programming", object_value: 1)
    Test::MemcachedAdapter.create(object_name: "Test", object_key: "YouTube-dev-channel", object_value: 1)
  end

  describe "#locked_by" do
    let(:locked_one) { Test::FakeLock.locked_by(lock_object_one) }
    let(:locked_two) { Test::FakeLock.locked_by(lock_object_two) }

    it "returns nil when lock does not exist" do
      allow(mock_adapter).to receive(:locked_by).and_return(locked_two)
      expect(mock_adapter.locked_by).to be_nil
    end

    it "returns user id = 1 when lock is existed" do
      allow(mock_adapter).to receive(:locked_by).and_return(locked_one)
      expect(mock_adapter.locked_by).to eq(1)
    end
  end

  describe "#lock_or_find" do
    let(:locked_one) { Test::FakeLock.lock_or_find(lock_object_one) }
    let(:locked_two) { Test::FakeLock.lock_or_find(lock_object_two) }

    context "when lock does not exist" do
      it "returns { has_locked: false, locked_by: 2 }" do
        allow(mock_adapter).to receive(:lock_or_find).and_return(locked_two)
        expect(mock_adapter.lock_or_find).to eq({ has_locked: false, locked_by: 2 })
      end
    end

    context "when lock is existed" do
      it "returns { has_locked: true, locked_by: 1 }" do
        allow(mock_adapter).to receive(:lock_or_find).and_return(locked_one)
        expect(mock_adapter.lock_or_find).to eq({ has_locked: true, locked_by: 1 })
      end
    end
  end

  describe "#unlock" do
    let(:locked) { Test::FakeLock.unlock(lock_object_one) }

    it "returns locked_key: 'Library-programming' of the unlocked object }" do
      allow(mock_adapter).to receive(:unlock).and_return(locked)

      expect(mock_adapter.unlock).to eq("Library-programming")
      expect(Test::MemcachedAdapter.get(object_name: "Test", object_key: "Library-programming")).to be_nil
    end
  end

  after do
    Test::MemcachedAdapter.delete(object_name: "Test", object_key: "Library-programming")
    Test::MemcachedAdapter.delete(object_name: "Test", object_key: "YouTube-dev-channel")
  end
end
