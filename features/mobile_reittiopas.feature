Feature: Mobile version of Reittiopas
  In order to have a better user experience
  As a mobile device user
  I want to be directed to the mobile version of Reittiopas

  @javascript
  Scenario: Finding a trip with the mobile version enabled
    Given I have saved a place "Home"
    And I have saved a place "Work"
    And I have logged in
    When I go to the settings page
    And I fill in "*" for "settings[mobile_browsers]"
    And I press "Save"
    And I go to the home page
    And I click on the place "Home"
    And I click on the place "Work"
    And I press "GO"
    And I wait for the page to load
    Then I should be shown the trip from "Home" to "Work" on the mobile version

  @javascript
  Scenario: The unsupported via field is not shown even if enabled
    Given I have logged in
    And I have enabled the via field
    And I have set the mobile browsers list to "*"
    When I go to the home page
    Then "Via" should be hidden
