Feature: Typing the username in the hostname
  In order to access the service quickly
  As an experienced user with no privacy concerns
  I want to be able to access my places by typing myusername.kiire.fi

  Scenario: Accessing places by typing myusername.kiire.fi
    Given there exists a user "kaylee"
    And "kaylee" has allowed viewing her places page without logging in
    And "kaylee" has saved a place "Ariel Alliance hospital"
    When I go to the host "kaylee.kiire.fi"
    Then I should see "Ariel Alliance hospital"
    But I should not see "Log out"

  Scenario: Logging in
    Given there exists a user "kaylee"
    And "kaylee" has allowed viewing her places page without logging in
    And I am on the host "kaylee.kiire.fi"
    When I follow "Log in"
    Then the "Username" field should contain "kaylee"
