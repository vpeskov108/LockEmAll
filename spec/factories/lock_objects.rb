FactoryBot.define do
  factory :lock_object, class: LockEmAll::LockObject do
    object_params { { object_name: "test_object", object_key: "test_key" } }
    object_value { 1 }

    initialize_with { new(object_params:, object_value:) }
  end
end
