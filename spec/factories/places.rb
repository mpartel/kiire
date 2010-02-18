Factory.sequence(:place_names) { |n| "place#{n}" }

Factory.define(:place) do |s|
  s.association :user
  s.name { Factory.next(:place_names) }
end
