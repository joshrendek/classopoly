require 'spec_lite'
require 'pry'
require 'valium'
require 'devise'
require './app/models/instructor_vote'
require './config/initializers/app_config'
require './config/initializers/devise'
require './app/models/friend'
require './app/models/instructor'
require './app/models/user'


describe InstructorVote do

  before(:each) do 
    @instructor = double('instructor')
    @user = double('user')

    @user.stub(:id => 1)
    @instructor.stub(:id => 1)

    InstructorVote.destroy_all
    Instructor.destroy_all

  end

  context "Validations" do 
    it "shouldn't let me vote twice" do
      InstructorVote.create(:user_id => @user.id, :instructor_id => @instructor.id).should be_valid 
      InstructorVote.create(:user_id => @user.id, :instructor_id => @instructor.id).should be_invalid 
    end
  end

  context "Ratings" do
    it "should show me the average rating for a teacher" do 
      instructor = Instructor.create!(:name => "Test Teacher", :college_id => 1)
      InstructorVote.create!(:user_id => 1, :instructor_id => instructor.id, :rating => 2)
      InstructorVote.create!(:user_id => 2, :instructor_id => instructor.id, :rating => 4)
      instructor.rating.should eq(3)
    end
  end
end
