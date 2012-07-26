Feature: Trip selector
  In order to not waste time and miss any connections by typing places into the suboptimal map service UI
  As a user in a big hurry
  I want to find a public transportation trip between two of my favorite places quickly

  Scenario: Seeing trip after authentication
    Given I have saved a place "Home"
    And I have saved a place "Work"
    When I have logged in
    Then I should see "Home"
    And I should see "Work"

  @javascript
  Scenario: Selecting two locations and finding a trip
    Given I have saved a place "Home"
    And I have saved a place "Work"
    And I have logged in
    When I click on the place "Home"
    And I click on the place "Work"
    And I press "GO"
    And I wait for the page to load
    Then I should be shown the trip from "Home" to "Work"

