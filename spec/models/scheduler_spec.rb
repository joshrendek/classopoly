require 'spec_lite'
require './app/models/scheduler'
require './app/models/course'
require 'pry'

describe Scheduler do
  before(:each) do 
    @course_list = []
    @course = double('course')

    @course.stub(id: 1, 
    course_number: "ACG2021", 
    section: "01", 
    reference_number: "00001", 
    begin_time: Time.parse("2000-01-01 15:10:00 Z"), 
    end_time: Time.parse("2000-01-01 16:00:00 Z"), 
    days: "MW", 
    college_id: 1)

    @course.stub(:days_array){ arr = ["monday", "wednesday"] }

    @course2 = double('course')
    @course2.stub(id: 2, 
    course_number: "ACG2021", 
    section: "01", 
    reference_number: "00002", 
    begin_time: Time.parse("2000-01-01 15:10:00 Z"), 
    end_time: Time.parse("2000-01-01 16:00:00 Z"), 
    days: "TR", 
    college_id: 1)

    @course2.stub(:days_array){ arr = ["tuesday", "thursday"] }

    @course_list << @course
    @course_list << @course2
  end

  context "should show occupied and course times" do

    it "should give me slices of time that are occupied" do 
      s = Scheduler2.new(["wednesday,8:30,14:30"], @course_list)
      s.occupied_time.first.start == 30600
      s.occupied_time.first.end == 52200
      s.occupied_time.first.day == "wednesday"
    end

    it "should give me slices of time for courses" do
      s = Scheduler2.new(["wednesday,8:30,14:30"], @course_list)
      s.course_times.first.start == 54600
      s.course_times.first.end == 57600
      s.course_times.first.days == "MW"
    end

  end

  context "should show me whether a course time is contained within occupied time " do 
    it "should show the time as free if i work on tuesday" do
      s = Scheduler2.new(["tuesday,8:30,14:30"], @course_list)
      first_course = s.course_times.first
      s.course_time_exists_in_occupied_time?(first_course).should be_false
    end

    it "should show the time as not free if i work on monday" do
      s = Scheduler2.new(["monday,8:30,22:30"], @course_list)
      first_course = s.course_times.first
      s.course_time_exists_in_occupied_time?(first_course).should be_true
    end

    # WIP 
    it "should show the time as free if i work on tuesday and have class on monday" do
      s = Scheduler2.new(["tuesday,8:30,22:30"], @course_list)
      first_course = s.course_times.first
      s.course_time_exists_in_occupied_time?(first_course).should be_false
    end

   it "should show the time as not free if I work during class" do
      s = Scheduler2.new(["monday,2:30,15:50"], @course_list)
      first_course = s.course_times.first
      s.course_time_exists_in_occupied_time?(first_course).should be_true
    end

    it "should show the time as free if i work on monday before class" do
      s = Scheduler2.new(["monday,2:30,15:05"], @course_list)
      first_course = s.course_times.first
      s.course_time_exists_in_occupied_time?(first_course).should be_false
    end

  end


  # context "A user wants to schedule around a course" do
  # it "should give 1 course when working on wed and friday" do
  # schedule = Scheduler.new("wednesday,8:30,14:30|friday,6:30,18:45",
  # @course.course_number, @course_list)
  # schedule.find_courses_in_slices
  # available_courses = schedule.available_courses
  # available_courses.size.should eq(1)
  # p available_courses
  # end
  # 
  # it "should give 2 courses when not working" do
  # schedule = Scheduler.new("",
  # @course.course_number, @course_list)
  # schedule.find_courses_in_slices
  # available_courses = schedule.available_courses
  # available_courses.size.should eq(1)
  # p available_courses
  # 
  # end
  # end
end

## 22 seconds to run the below
# require 'spec_helper'
# 
# courses_yml = YAML.load_file('courses.yml')
# if Course.all.size < 6000
# courses_yml.each do |c|
# begin; Course.create(c.attributes); rescue; end; 
# end
# end
# 
# 
# describe Scheduler do
# 
# user1 = {"work_times" => "wednesday,8:30,14:30|friday,6:30,18:45", :lunch_time => "1:30", "course_tags" => ['ACG3341', 'CLT3370']}
# describe "Parsing the work_times" do
# it "should find 5 courses given I work on wednesday and friday" do
# user_schedule = Scheduler.new(user1["work_times"], user1["course_tags"])
# user_schedule.find_courses_in_slices
# user_schedule.available_courses.size.should == 5
# user_schedule.courses.size.should == 8
# end
# user2 = {"work_times" => "monday,6:00,12:00|friday,6:00,12", "course_tags" => ['BSC2010', 'CHI1120']}
# it "should find 3 courses given I work on monday and friday" do
# user_schedule = Scheduler.new(user2["work_times"], user2["course_tags"])
# user_schedule.find_courses_in_slices
# user_schedule.available_courses.size.should == 6
# user_schedule.courses.size.should == 9
# end
# 
# user3 = {"work_times" => "monday,00:01,23:00|tuesday,00:01,23:00|wednesday,00:01,23:00|thursday,00:01,23:00|friday,00:01,23:00", "course_tags" => Course.limit(3).collect {|c| c.course_number } }
# it "should find no courses given I work everyday from 00:01AM to 11PM" do
# user_schedule = Scheduler.new(user3["work_times"], user3["course_tags"])
# user_schedule.find_courses_in_slices
# user_schedule.available_courses.size.should == 0
# user_schedule.courses.size.should == 9
# 
# end
# 
# it "should convert a time to seconds" do
# user_schedule = Scheduler.new(user3["work_times"], user3["course_tags"])
# user_schedule.time_to_seconds(Time.local(2011, "jan", 1, 20, 15)).should == 72900
# end
# 
# it "should parse to time slices" do 
# user_schedule = Scheduler.new(user3["work_times"], user3["course_tags"])
# user_schedule.time_hash.size.should == 5
# user_schedule.time_hash.each do |t|
# t.size.should == 2
# end
# 
# end
# 
# 
# 
# 
# 
# 
# 
# end
# 
# 
# end
