Factory.sequence(:username) { |n| "user#{n}" }

Factory.define(:user) do |u|
  u.username { Factory.next(:username) }
  u.password_hash { User.hash_password('masterful') }
  u.password_confirmation {|u| u.password }
  u.email {|u| "#{u.username}@example.com" }
end