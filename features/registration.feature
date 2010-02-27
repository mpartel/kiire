Feature: registration
  In order to use the service
  As a new user
  I want to create an account

  Scenario: navigating to the registration page
    Given I am on the home page
    When I follow "Register"
    Then I should be on the registration page

  Scenario: creating an account
    Given I am on the registration page
    When I fill in "Username" with "jussi"
    And I fill in "Password" with "sussi"
    And I fill in "Password confirmation" with "sussi"
    And I press "Create account"
    Then I should be on the login page
    And a user "jussi" has been created
