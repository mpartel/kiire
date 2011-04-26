Feature: Reordering places
  In order to group related places logically
  As a user that has a lot of places
  I want to reorder the places

  @javascript
  Scenario:
    Given I have saved a place "Home"
    And I have saved a place "Work"
    And I have saved a place "Play"
    And I have logged in
    And I am on the settings page
    When I move "Home" after "Work"
    And I go to the home page
    Then I should see "Work" before "Home"
    And I should see "Home" before "Play"
