Given /^I have no active session$/ do
  cookies.clear
end

When /^I fill in my username$/ do
  @my_user ||= Factory.create(:user)
  fill_in("Username", :with => @my_user.username)
end

When /^I fill in my password$/ do
  @my_user ||= Factory.create(:user)
  @my_user.password = 'furniture'
  @my_user.password_confirmation = 'furniture'
  @my_user.save
  fill_in("Password", :with => @my_user.password)
end
