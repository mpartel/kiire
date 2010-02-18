Feature: Route selector
  In order to not waste time and miss any connections by typing places into the suboptimal map service UI
  As a user in a big hurry
  I want to find a public transportation route between two of my favorite places quickly

  Scenario: Seeing routes after authentication
    Given I have saved a place "Home"
    And I have saved a place "Work"
    When I have logged in
    Then I should see "Home"
    And I should see "Work"

  Scenario Outline: Selecting two locations and finding a route
    Given I have saved a place "Home"
    And I have saved a place "Work"
    And I have logged in
    When I click "Home"
    And I click "Work"
    And I click "GO NOW"
    Then I should be shown the route from "Home" to "Work"

