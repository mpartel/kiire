Factory.sequence(:place_names) { |n| "place#{n}" }
Factory.sequence(:place_ordinals) { |n| n }

Factory.define(:place) do |s|
  s.association :user
  s.name { Factory.next(:place_names) }
  s.ordinal { Factory.next(:place_ordinals) }
end
