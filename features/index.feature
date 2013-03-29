Feature: Default page test
    In order to test with Behat
    As a web developer
    I need to create and run tests

Scenario: Test link to demo
    Given I am on the homepage
    When I press "Run The Demo"
    Then the response status code should be 200
    And I should be on "/demo/"
