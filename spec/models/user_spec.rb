require 'spec_helper'

courses_yml = YAML.load_file('courses.yml')
if Course.all.size < 6000
  courses_yml.each do |c|
    begin; Course.create(c.attributes); rescue; end; 
  end
end
p Course.all.size

class Schedule
  DEBUG = false
  require 'set'
  require 'digest/md5'  
  attr_accessor :datetime_hash, :course_tags, :available_classes, :courses

  def initialize(str, tag)
    @time_hash = {}
    @course_tags = tag
    @available_courses = {}
    str.split('|').each do |day_string|
      tmp = day_string.split(',')
      day = tmp[0]
      parse_to_time_slices(day,tmp[1..-1])
    end
  end
  
  def available_courses
    @available_courses
  end

  def courses
    @courses
  end

  def time_to_seconds(time)
    time.hour * 60 * 60 + time.min * 60 
  end

  def parse_to_time_slices(day, times)
    date_array = (Date.today.at_beginning_of_month..Date.today.at_beginning_of_month.advance(:weeks => 1))
    time_hash = {}
    date_array.each do |d|
      time_hash.store(d.strftime("%A"), [Time.parse("#{d} #{times[0]}"), Time.parse("#{d} #{times[1]}")]) # store the date objects in a hash with the date as a key
    end
    print time_hash.to_yaml if DEBUG
    @time_hash.store(day, time_hash[day.capitalize])
  end

  def find_courses_in_slices
    available_courses = {}

    # find all courses that include the course tags they're enrolled in
    @courses = Course.where(:course_number => @course_tags)

    @courses.each do |c|
      # turn the time of the class into a time set  
      time_slice = (c.begin_time.localtime.to_i...c.end_time.localtime.to_i).to_a.to_set
      # loop through each time slice from when they work
      @time_hash.each do |k,t|
        # might be a conflict if the class is on the same day they work, time to check times

        # create two time sets for class and work 
        class_time_range = (time_to_seconds(c.begin_time)..time_to_seconds(c.end_time)).to_a.to_set
        work_time_range = (time_to_seconds(t[0].localtime)..time_to_seconds(t[1].localtime)).to_a.to_set
        p "_"*60 if DEBUG
        p "#{t[0].localtime} #{t[1].localtime}" if DEBUG
        p "#{work_time_range.to_a[0]} #{work_time_range.to_a[-1]}" if DEBUG
        p "#{time_to_seconds(t[0].localtime)} #{time_to_seconds(t[1].localtime)}" if DEBUG
        p "_"*60 if DEBUG

        # if the class time isnt a subset of the work time, we can add it to the available courses hash
        if class_time_range.subset?(work_time_range) == false
          # store the crouse inside the available_courses hash with Course.to_s MD5'd as a key
          available_courses.store(Digest::MD5.hexdigest(c.to_s), c)
          p k + " -> " + c.days_array.join(',') + " [] #{class_time_range.to_a[0]}-#{class_time_range.to_a[-1]} <=> #{work_time_range.to_a[0]}-#{work_time_range.to_a[-1]}" if DEBUG
        else
          p "Couldn't add course: #{c.id}" if DEBUG
          print "\t" + k + " -> " + c.days_array.join(',') + " [] #{class_time_range.to_a[0]}-#{class_time_range.to_a[-1]} <=> #{work_time_range.to_a[0]}-#{work_time_range.to_a[-1]}\n" if DEBUG

        end
      end 
      #p time_slice
    end
    p "#{available_courses.size}/#{@courses.size} courses have been found to fit your schedule " if DEBUG
    @available_courses = available_courses 
    p "="*60 if DEBUG
  end

  def to_s
    @time_hash.each do |d|
      p d
    end
    return
  end
end

describe User do

  user1 = {"work_times" => "wednesday,8:30,14:30|friday,6:30,18:45", :lunch_time => "1:30", "course_tags" => ['ACG3341', 'CLT3370']}
  days = Date::DAYNAMES
  describe "Parsing the work_times" do
    it "should find 5 courses given I work on wednesday and friday" do
      user_schedule = Schedule.new(user1["work_times"], user1["course_tags"])
      user_schedule.find_courses_in_slices
      user_schedule.available_courses.size.should == 5
      user_schedule.courses.size.should == 8
    end
    user2 = {"work_times" => "monday,6:00,12:00|friday,6:00,12", "course_tags" => ['BSC2010', 'CHI1120']}
    it "should find 3 courses given I work on monday and friday" do
      user_schedule = Schedule.new(user2["work_times"], user2["course_tags"])
      user_schedule.find_courses_in_slices
      user_schedule.available_courses.size.should == 4
      user_schedule.courses.size.should == 9
    end

    user3 = {"work_times" => "monday,00:01,23:00|tuesday,00:01,23:00|wednesday,00:01,23:00|thursday,00:01,23:00|friday,00:01,23:00", "course_tags" => ['BSC2010', 'CHI1120']}
    it "should find no courses given I work everyday from 00:01AM to 11PM" do
      user_schedule = Schedule.new(user3["work_times"], user3["course_tags"])
      user_schedule.find_courses_in_slices
      user_schedule.available_courses.size.should == 0
      user_schedule.courses.size.should == 9

    end





  end


end
