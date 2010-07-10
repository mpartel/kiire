Feature: Showing the via field
  In order to get a route via a given place
  As a user who uses that feature of Reittiopas frequently
  I want to have a third via field on my main page

  Scenario: by default the via field is disabled
    Given I have logged in as "kalle"
    When I go to the home page
    Then I should not see "Via"

  Scenario: enabling the via field in settings
    Given I have logged in as "kalle"
    When I go to the settings page
    And I check "settings_show_via_field"
    And I press "Save"
    And I go to the home page
    Then I should see "Via"
