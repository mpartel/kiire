
Given /^there exists a user "([^\"]*)"$/ do |username|
  Factory.create(:user, :username => username)
end

Then /^a user "([^\"]*)" has been created$/ do |username|
  User.find_by_username(username).should_not be_nil
end

Given /^"([^\"]*)" has allowed viewing her places page without logging in$/ do |username|
  user = User.find_by_username(username)
  setting = user.get_setting('dont_require_login')
  setting.value = '1'
  setting.save!
end
