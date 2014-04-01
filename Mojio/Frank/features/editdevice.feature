Feature: 
  As the tester 
  I want to have a feature test file
  So I can see if modifing devices is working correctly.

Scenario: 
  Attempt to modify the attributes of the device and back. 
Given I reset the simulator
And I launch the app
#When I touch the button marked "Login"
When I wait to see a navigation bar titled "Login"
When I type "team31" into the "UsernameTextField" text field
When I type "Teamthirty1" into the "PasswordTextField" text field
When I wait for 5 second
When I touch the button marked "Login"
Then I wait to not see a navigation bar titled "Login"
When I touch2 "Devices"
When I wait for 5 second
When I touch2 "Moms Car"
When I wait for 5 second
Then I wait to see a navigation bar titled "Edit"
When I wait for 5 second
Then I touch2 "Set as Active Device"
When I wait for 5 second
Then I touch2 "Save Changes"
When I wait for 5 second
Then I navigate back
When I wait for 5 second
Then I wait to see a navigation bar titled "Moms Car"
