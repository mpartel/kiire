
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

When /^I move "([^"]*)" after "([^"]*)"$/ do |place1, place2|
  place1 = Place.find_by_name(place1).id
  place2 = Place.find_by_name(place2).id unless place2 == 'top'
  find(:css, "tr#place-#{place1} select.move-after option[value=\"#{place2}\"]").select_option
end
