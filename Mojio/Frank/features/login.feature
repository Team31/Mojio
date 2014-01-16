Feature: 
  As the tester 
  I want to have a feature test file
  So I can see if or login is working correctly.

Scenario: 
  Open the app and attempt to press the login button. 
Given I launch the app
When I touch the button marked "Login"
Then I wait to see a navigation bar titled "Login"

Scenario: 
   Attempt to login the app using predefined user/pass. 
When I fill in "UsernameTextField" with "team31"
When I fill in "PasswordTextField" with "TeamThirty1"
When I touch the button marked "Login"
Then I wait to not see a navigation bar titled "Login"

Scenario: 
   Attempt to login the app using predefined user/pass. 
When I type "team31" into the "UsernameTextField" text field
When I type "Teamthirty1" into the "PasswordTextField" text field
When I touch the button marked "Login"
Then I wait to not see a navigation bar titled "Login"
