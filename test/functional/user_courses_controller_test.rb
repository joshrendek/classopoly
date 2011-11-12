require 'test_helper'

class UserCoursesControllerTest < ActionController::TestCase
  setup do
    @user_course = user_courses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_courses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_course" do
    assert_difference('UserCourse.count') do
      post :create, user_course: @user_course.attributes
    end

    assert_redirected_to user_course_path(assigns(:user_course))
  end

  test "should show user_course" do
    get :show, id: @user_course.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_course.to_param
    assert_response :success
  end

  test "should update user_course" do
    put :update, id: @user_course.to_param, user_course: @user_course.attributes
    assert_redirected_to user_course_path(assigns(:user_course))
  end

  test "should destroy user_course" do
    assert_difference('UserCourse.count', -1) do
      delete :destroy, id: @user_course.to_param
    end

    assert_redirected_to user_courses_path
  end
end
