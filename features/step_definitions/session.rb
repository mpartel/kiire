Given /^I have no active session$/ do
  #cookies.clear
end

Given /^I have logged in(?: as "([^"]*)")?$/ do |username|
  @my_user ||= Factory.build(:user)
  @my_user.username = username if username
  @my_user.password = 'furniture'
  @my_user.password_confirmation = 'furniture'
  @my_user.save!
  
  visit path_to("the homepage")
  page.should have_content("Username")
  fill_in "Username", :with => @my_user.username
  fill_in "Password", :with => @my_user.password
  click_button "Log in"
  page.should have_content("Log out")
end

When /^I fill in my username$/ do
  @my_user ||= Factory.create(:user)
  fill_in("Username", :with => @my_user.username)
end

When /^I fill in my password$/ do
  @my_user ||= Factory.build(:user)
  @my_user.password = 'furniture'
  @my_user.password_confirmation = 'furniture'
  @my_user.save!
  fill_in("Password", :with => @my_user.password)
end
