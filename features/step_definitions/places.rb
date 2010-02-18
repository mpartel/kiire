
Given /^I have saved a place "([^\"]*)"$/ do |name|
  @my_user ||= Factory.create(:user)
  Factory.create(:place, :user => @my_user, :name => name)
end
