FactoryBot.define do
  factory :lock_object, class: LockEmAll::LockObject do
    object_params { { object_name: "test_object", object_key: "test_key" } }
    user_id { 1 }

    initialize_with { new(object_params:, user_id:) }
  end
end
