
When /^I click on the place "([^"]*)"$/ do |link|
  find('li.place', :text => link).click
end

Then /^I should be shown the trip from "([^"]*)" to "([^"]*)"$/ do |from, to|
  # This even works without an internet connection
  for part in ['reittiopas.fi', 'from_in=Home', 'to_in=Work']
    current_url.should include(part)
  end
end

Given /^I have saved a place "([^\"]*)"$/ do |name|
  Factory.create(:place, :user => current_user, :name => name)
end

Given /^"([^\"]*)" has saved a place "([^\"]*)"$/ do |username, name|
  user = User.find_by_username(username)
  Factory.create(:place, :user => user, :name => name)
end
