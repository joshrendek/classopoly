require 'spec_lite'
require './app/models/instructor_vote'
require 'devise'
require './config/initializers/app_config'
require './config/initializers/devise'
require './app/models/friend'
require './app/models/user'
require 'pry'


describe InstructorVote do

  before(:each) do 
    @instructor = double('instructor')
    @user = double('user')

    @user.stub(:id => 1)
    @instructor.stub(:id => 1)

    InstructorVote.destroy_all

  end

  context "Validations" do 
    it "shouldn't let me vote twice" do
      InstructorVote.create(:user_id => @user.id, :instructor_id => @instructor.id).should be_valid 
      InstructorVote.create(:user_id => @user.id, :instructor_id => @instructor.id).should be_invalid 
    end
  end
end
