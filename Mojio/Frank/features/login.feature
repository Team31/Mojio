Feature: 
  As the tester 
  I want to have a feature test file
  So I can see if or login is working correctly.

Scenario: 
   Attempt to login the app using predefined user/pass. 
Given I launch the app
When I touch the button marked "Login"
Then I wait to see a navigation	bar titled "Login"
