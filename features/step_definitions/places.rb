
When /^I click on the place "([^"]*)"$/ do |link|
  find('li.place', :text => link).click
end

Then /^I should be shown the trip from "([^"]*)" to "([^"]*)"$/ do |from, to|
  # This even works without an internet connection
  for part in ['reittiopas.fi', 'from_in=' + from, 'to_in=' + to]
    current_url.should include(part)
  end
end

Then /^I should be shown the trip from "([^"]*)" to "([^"]*)" on the mobile version$/ do |from, to|
  for part in ['aikataulut.hsl.fi/reittiopas-pda', 'keya=' + from, 'keyb=' + to]
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
