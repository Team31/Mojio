Feature: 
  As the tester 
  I want to have a feature test file
  So I can see if logout is working correctly.

Scenario: 
  Attempt to logout the app. 
Given I reset the simulator 
Given I launch the app
When I touch the button marked "Login"
Then I wait to see a navigation bar titled "Login"
When I type "team31" into the "UsernameTextField" text field
When I type "Teamthirty1" into the "PasswordTextField" text field
When I wait for 5 second
When I touch the button marked "Login"
When I wait for 5 second
Then I wait to not see a navigation bar titled "Login"
When I wait for 5 second
Then I touch2 "LogOut"
When I wait for 5 second
Then I wait to not see a navigation bar titled "Login"

