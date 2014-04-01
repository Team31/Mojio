Feature: 
  As the tester 
  I want to have a feature test file
  So I can see if or login is working correctly.

Scenario: 
  Attempt to login the app using valid user/pass. 
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
Then I touch2 "LogOut"

Scenario: 
   Attempt to login the app using invalid user/pass. 
Given I launch the app
When I touch the button marked "Login"
Then I wait to see a navigation bar titled "Login"
When I type "test" into the "UsernameTextField" text field
When I type "nopass" into the "PasswordTextField" text field
When I wait for 5 second
When I touch the button marked "Login"
When I wait for 5 second
Then I should see "Invalid password or username"
