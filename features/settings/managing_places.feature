Feature: Managing places
  In order to plan trips to my regular destinations more quickly
  As a regular user
  I want to bookmark the places I got to often

  Scenario: Bookmarking a place
    Given I have logged in
    And I am on the settings page
    When I fill in "Name" with "Rautatieasema"
    And I press "Add place"
    Then I should be on the settings page
    And I should see "Rautatieasema" within "#my-places"

  Scenario: Seeing bookmarked places
    Given I have saved a place "Home"
    And I have saved a place "Work"
    And I have logged in
    When I am on the settings page
    Then I should see "Home"
    And I should see "Work"