Factory.sequence(:place_setting_keys) {|n| "ps#{n}" }

Factory.define(:place_setting) do |ps|
  ps.association :place
  ps.backend nil
  ps.key { Factory.next(:place_setting_keys) }
  ps.value nil
end