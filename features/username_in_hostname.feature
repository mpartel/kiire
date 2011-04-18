Feature: Typing the username in the hostname
  In order to access the service quickly
  As an experienced user with no privacy concerns
  I want to be able to access my places by typing myusername.kiire.fi

  Scenario: Accessing places by typing myusername.kiire.fi
    Given there exists a user "kaisa"
    And "kaisa" has allowed viewing her places page without logging in
    And "kaisa" has saved a place "Aleksandria"
    When I go to the host "kaisa.kiire.fi"
    Then I should see "Aleksandria"
    But I should not see "Log out"

  Scenario: Logging in
    Given there exists a user "kaisa"
    And "kaisa" has allowed viewing her places page without logging in
    And I am on the host "kaisa.kiire.fi"
    When I follow "Log in"
    Then the "Username" field should contain "kaisa"
