Feature: Visit the home page
  
  Scenario: Visiting the homepage
    Given I am on the homepage 
    Then I should see "Get started in 3 easy steps"

  Scenario: I visit the homepage from a referral link
    Given I visit the home page from a invite link
    Then the pending invite should no longer exist


  Scenario Outline: Creating a new account
    Given I am not authenticated
    When I go to register
    And I fill in "user_email" with "<email>"
    And I fill in "user_password" with "<password>"
    And I fill in "user_password_confirmation" with "<password>"
    And I press "Sign up"
    Then I should see "Invite Your Friends"

    Examples:
      | email           | password   |
      | testing@man.net | secretpass |
      | foo@bar.com     | fr33z3     |
