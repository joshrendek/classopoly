require 'spec_lite'
require './app/models/course'

describe Course do

  before(:all) do 
    @spring = Course.create(:year => 2012, :term => "20121", :course_college_instructor_hash => "123")
    @fall = Course.create(:year => 2012, :term => "20129", :course_college_instructor_hash => "1233")
    @summer = Course.create(:year => 2012, :term => "20126", :course_college_instructor_hash => "13423")
  end

  after(:all) do
    Course.destroy_all
  end

  context "Getting a courses term" do
    it "should give me fall for 9" do 
      @fall.human_term.should == "fall"
    end

    it "should give me spring for 1" do
      @spring.human_term.should == "spring"
    end

    it "should give me summer for 6" do
      @summer.human_term.should == "summer"
    end

  end

end
