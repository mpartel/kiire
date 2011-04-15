Given /^I have no active session$/ do
  #cookies.clear
end

Given /^I have logged in(?: as "([^"]*)")?$/ do |username|
  current_user.username = username if username
  current_user.password = 'furniture'
  current_user.password_confirmation = 'furniture'
  current_user.save!
  
  visit path_to("the homepage")
  page.should have_content("Username")
  fill_in "Username", :with => current_user.username
  fill_in "Password", :with => current_user.password
  click_button "Log in"
  page.should have_content("Log out")
end

When /^I fill in my username$/ do
  fill_in("Username", :with => current_user.username)
end

When /^I fill in my password$/ do
  current_user.password = 'furniture'
  current_user.password_confirmation = 'furniture'
  current_user.save!
  fill_in("Password", :with => current_user.password)
end
