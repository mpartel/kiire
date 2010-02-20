Feature: Adding places
  In order to plan trips to my regular destinations more quickly
  As a regular user
  I want to bookmark the places I got to often

  Scenario Outline: Bookmarking a place
    Given I have logged in
    And I am on the settings page
    When I fill in "New place" with "Rautatieasema"
    And I click "Add place"
    Then I should be on the settings page
    And I should see "Rautatieasema" within "My places"
