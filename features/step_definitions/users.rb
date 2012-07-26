
Given /^there exists a user "([^\"]*)"$/ do |username|
  FactoryGirl.create(:user, :username => username)
end

Then /^a user "([^\"]*)" has been created$/ do |username|
  User.find_by_username(username).should_not be_nil
end
