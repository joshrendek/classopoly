require 'test_helper'

class FacebookControllerTest < ActionController::TestCase
  test "should get friends" do
    get :friends
    assert_response :success
  end

end
