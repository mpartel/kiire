Then /^"([^"]*)" should be hidden$/ do |thing|
  amount = page.evaluate_script("$(':contains(\"#{thing}\"):not(:visible)').length")
  amount.should > 0
end

When /^I wait for the page to load$/ do
  sleep 2 # how to do this better?
end

When /^I stare at the page for a moment$/ do
  sleep 5
end