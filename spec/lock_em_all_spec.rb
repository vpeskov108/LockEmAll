require "spec_helper"

RSpec.describe LockEmAll do
  it "has a version number" do
    expect(LockEmAll::VERSION).not_to be nil
  end

  it "returns default none adapter name" do
    expect(described_class.adapter).to be :none
  end
end
