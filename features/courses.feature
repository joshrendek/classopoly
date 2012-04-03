Feature: Courses

  # Scenario: Filling out preferences
    # Given I am a new, authenticated user
    # When I follow "Morning"
    # And I follow "Next >"
    # And I follow "Next >"
    # And I follow "Save Preferences"
    # Then I should see "You need to add some courses to take"
  # 
  # @javascript
  Scenario: Choosing a course
    Given I am a authenticated user with preferences
    When I follow "You need to add some courses to take"  
    When I follow "Add Course"
    When I press "Add Course"
    Then I should see "Listing Courses You Want to Take"
    
