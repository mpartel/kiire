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
    And I should see "New place added"
    And I should see "Rautatieasema" within "#places-manager"

  Scenario: Seeing bookmarked places
    Given I have saved a place "Home"
    And I have saved a place "Work"
    And I have logged in
    When I am on the settings page
    Then I should see "Home"
    And I should see "Work"

  Scenario: Deleting bookmarked places
    Given I have saved a place "Home"
    And I have saved a place "Work"
    And I have logged in
    And I am on the settings page
    When I follow "delete" within "td.delete"
    Then I should be on the settings page
    And I should see "Place deleted"
    And I should not see "Home"
    But I should see "Work"

  #TODO: reordering

  Scenario: Renaming a place
    Given I have logged in
    And I have saved a place "Work"
    And I am on the settings page
    When I follow "edit" within "td.edit"
    And I fill in "Zork" for "Name"
    And I press "Save"
    Then I should see "Place updated"
    And I should be on the settings page
    And I should see "Zork"
    But I should not see "Work"

  Scenario: Assigning a backend name to a place
    Given I have logged in
    And I have saved a place "Aukio"
    And I am on the edit page of the place "Aukio"
    When I fill in "Mannerheimintie 3 B" for "Address for Reittiopas"
    And I press "Save"
    Then I should see "Place updated"
    And  I should be on the settings page
    And I should see "Aukio"
    But I should not see "Mannerheimintie 3 B"

