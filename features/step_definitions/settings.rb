
Given /^"([^\"]*)" has allowed viewing her places page without logging in$/ do |username|
  user = User.find_by_username(username)
  setting = user.get_setting('dont_require_login')
  setting.value = '1'
  setting.save!
end
