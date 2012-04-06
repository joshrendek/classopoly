require 'spec_helper'

describe User do
  before(:each) do 
    @course = double('course')
    @user = double('user')
    @user.stub(:id => 1)


    @friend = double('user')
    @friend.stub(:id => 2)

    @course.stub(id: 1, 
    course_number: "ACG2021", 
    begin_time: Time.new(2000, 1, 1, 15, 10),
    end_time: Time.new(2000, 1, 1, 16, 00),
    days: "MW")

    @user.stub(:find_friends_courses => [@course])

    @user.stub(:courses => [@course])
    @friend.stub(:courses => [@course])

  end

  context "find friends courses" do 
    it "should find courses that friends are in" do 
      @user.find_friends_courses.should == [@course]
    end
  end

  context "displaying user information" do
    it "shouldn't show a users full name" do
      @user = User.new(:name => "Test User")
      @user.safe_name.should == "Test U."
    end
  end


end
