Feature: Default page test
    In order to test with Behat
    As a web developer
    I need to create and run tests

@javascript
Scenario: Test link to demo
    Given I am on the homepage
    When I follow "Run The Demo"
    #Then the response status code should be 200
    Then I should be on "/demo/"
