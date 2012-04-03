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

    # @user.stub(:find_friends_courses => [@course])

    @user.stub(:courses => [@course])
    @friend.stub(:courses => [@course])

  end

  context "Should find a friends courses" do 
    @user.find_friends_courses.should == [@course]
  end
end
