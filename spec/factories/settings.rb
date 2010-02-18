Factory.sequence(:setting_keys) { |n| "key#{n}" }

Factory.define(:setting) do |s|
  s.association :user
  s.key { Factory.next(:setting_keys) }
  s.value nil
end
