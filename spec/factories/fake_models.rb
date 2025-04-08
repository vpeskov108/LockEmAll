FactoryBot.define do
  factory :fake_model, class: "FakeModel" do
    object_name { "Test-name" }
    object_key { "Test-key" }
    object_value { 1 }

    initialize_with { new(object_name:, object_key:, object_value:) }
  end
end
