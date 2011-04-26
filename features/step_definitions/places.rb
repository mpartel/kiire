
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

Then /^I should see "([^"]*)" before "([^"]*)"$/ do |place1, place2|
  places = all(:css, "li.place")
  i1 = nil
  i2 = nil
  places.each_with_index do |place, i|
    i1 = i if place.text.strip == place1
    i2 = i if place.text.strip == place2
  end
  if i1 && i2
    fail("#{place1} was not before #{place2}") if i1 >= i2
  else
    fail("No such place: " + place1) if !i1
    fail("No such place: " + place2) if !i2
  end
end
