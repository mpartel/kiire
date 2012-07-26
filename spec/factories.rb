FactoryGirl.define do
  factory :user do
    sequence(:username) {|n| "user#{n}" }
    sequence(:password_hash) { User.hash_password("password#{n}") }
    after(:build) do |u|
      u.password_confirmation = u.password
      u.email = "#{u.username}@example.com"
    end
  end

  factory :setting do
    user
    sequence(:key) {|n| "key#{n}" }
    value nil
  end

  factory :place do
    user
    sequence(:name) {|n| "place#{n}" }
    sequence(:ordinal) {|n| n }
  end

  factory :place_setting do
    place
    backend nil
    sequence(:key) {|n| "ps#{n}" }
    value nil
  end
end
