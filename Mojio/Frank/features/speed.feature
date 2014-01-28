Feature: 
  As the tester 
  I want to have a feature test file
  So I can see if speed selection is working correctly.

Scenario: 
  Attempt to modify the speed limit of the device and back. 
Given I launch the app
When I touch the button marked "Login"
Then I wait to see a navigation bar titled "Login"
When I type "team31" into the "UsernameTextField" text field
When I type "Teamthirty1" into the "PasswordTextField" text field
When I wait for 1 second
When I touch the button marked "Login"
Then I wait to not see a navigation bar titled "Login"
When I touch the button marked "Speed Selection"
And I touch "Mile"
Then I wait for 1 second
And I touch "70"
Then I wait for 1 second
And I touch "Set"
Then I wait for 1 second
And I wait to see "50" in the "currentSpeed" text field
