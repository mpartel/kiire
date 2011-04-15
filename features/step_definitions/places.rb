
Given /^I have saved a place "([^\"]*)"$/ do |name|
  Factory.create(:place, :user => current_user, :name => name)
end

Given /^"([^\"]*)" has saved a place "([^\"]*)"$/ do |username, name|
  user = User.find_by_username(username)
  Factory.create(:place, :user => user, :name => name)
end
