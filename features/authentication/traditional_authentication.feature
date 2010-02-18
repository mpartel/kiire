Feature: Authentication (traditional login)
  In order to access the service
  As a new user with full password protection
  I want to be able to log in to the service from the front page

  Scenario: Seeing the login prompt.
    Given I have no active session
    When I am on the home page
    Then I should see "Username"
    And I should see "Password"

  Scenario: Logging in
    Given I have no active session
    And I am on the home page
    When I fill in my username
    And I fill in my password
    And I press "Log in"
    Then I should be on the home page
    And I should see "Log out"
