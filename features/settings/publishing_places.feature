Feature: Publishing places
  In order to access my places faster
  As a user that doesn't want to log in
  I want to permit access to my main page without logging in

  Scenario: initially the main page isn't accessible without logging in
    Given there exists a user "kalle"
    When I go to the page showing the places of "kalle"
    Then I should be on the login page

  Scenario: setting the main page the be accessible without logging in
    Given I have logged in as "kalle"
    When I go to the settings page
    And I check "Don't require login"
    And I press "Save"
    And I follow "Log out"
    And I go to the page showing the places of "kalle"
    Then I should be on the page showing the places of "kalle"
    And I should see "Log in"
