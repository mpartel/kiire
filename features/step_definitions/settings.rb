
Given /^"([^\"]*)" has allowed viewing her places page without logging in$/ do |username|
  user = User.find_by_username(username)
  setting = user.get_setting('dont_require_login')
  setting.value = '1'
  setting.save!
end

Given /^I have enabled the via field$/ do
  setting = current_user.get_setting('show_via_field')
  setting.value = '1'
  setting.save!
end

Given /^I have set the mobile browsers list to "([^"]*)"$/ do |value|
  setting = current_user.get_setting('mobile_browsers')
  setting.value = value
  setting.save!
end
