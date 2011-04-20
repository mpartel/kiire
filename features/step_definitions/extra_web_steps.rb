Then /^"([^"]*)" should be hidden$/ do |thing|
  amount = page.evaluate_script("$(':contains(\"#{thing}\"):not(:visible)').length")
  amount.should > 0
end