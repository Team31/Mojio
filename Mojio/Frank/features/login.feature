Feature: 
  As the tester 
  I want to have a feature test file
  So I can see if or login is working correctly.

Scenario: 
  Attempt to login the app using valid user/pass. 
Given I launch the app
When I touch the button marked "Login"
Then I wait to see a navigation bar titled "Login"
When I type "team31" into the "UsernameTextField" text field
When I type "Teamthirty1" into the "PasswordTextField" text field
When I wait for 1 second
When I touch the button marked "Login"
Then I wait to not see a navigation bar titled "Login"

Scenario: 
   Attempt to login the app using invalid user/pass. 
Given I launch the app
When I touch the button marked "Login"
Then I wait to see a navigation bar titled "Login"
When I type "test" into the "UsernameTextField" text field
When I type "nopass" into the "PasswordTextField" text field
When I wait for 1 second
When I touch the button marked "Login"
Then I should see "Username and password combination incorrect."
