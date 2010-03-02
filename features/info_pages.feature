Feature: info pages
  In order to learn about the site
  As a new visitor
  I want to read a description
  Scenario: accessing info pages from the login page
    Given I am on the login page
    When I follow "About the site"
    Then I should be on the information page
