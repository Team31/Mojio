Feature: 
  As the tester 
  I want to have a feature test file
  So I can see if violation menu is working correctly.

Scenario: 
  Check whether or not we can access the violation menu 
Given I reset the simulator
Given I launch the app
When I touch the button marked "Login"
Then I wait to see a navigation bar titled "Login"
When I type "team31" into the "UsernameTextField" text field
When I type "Teamthirty1" into the "PasswordTextField" text field
When I wait for 2 second
When I touch the button marked "Login"
Then I wait to not see a navigation bar titled "Login"
When I touch2 "tickets"
Then I wait for 2 second
Then I wait to see a navigation bar titled "Speed Violations"
