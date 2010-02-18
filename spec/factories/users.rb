Factory.sequence :username do |n|
  good_guys = ['mal', 'zoe', 'wash', 'jayne', 'inara', 'kaylee', 'river', 'simon', 'book']
  name = good_guys[n % good_guys.length]
  round = n / good_guys.length
  name += '_' + round.to_s unless round == 0
  name
end

Factory.define(:user) do |u|
  u.username { Factory.next(:username) }
  u.password_hash { User.hash_password('masterful') }
  u.password_confirmation {|u| u.password }
  u.email {|u| "#{u.username}@example.com" }
end