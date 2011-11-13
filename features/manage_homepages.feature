Feature: Visit the home page
  
  Scenario: Visiting the homepage
    Given I am on the homepage 
    Then I should see "Welcome to Classopoly! You can begin by logging in and adding some courses."



  Scenario Outline: Creating a new account
    Given I am not authenticated
    When I go to register
    And I fill in "user_email" with "<email>"
    And I fill in "user_password" with "<password>"
    And I fill in "user_password_confirmation" with "<password>"
    And I press "Sign up"
    Then I should see "When do you like to take your classes"

    Examples:
      | email           | password   |
      | testing@man.net | secretpass |
      | foo@bar.com     | fr33z3     |
