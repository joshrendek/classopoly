require 'spec_helper'

courses_yml = YAML.load_file('courses.yml')
if Course.all.size < 6000
  courses_yml.each do |c|
    begin; Course.create(c.attributes); rescue; end; 
  end
end
p Course.all.size

class Schedule
  require 'set'
  require 'digest/md5'  
  attr_accessor :datetime_hash, :course_tags

  def initialize(str, tag)
    @time_hash = {}
    @course_tags = tag
    str.split('|').each do |day_string|
      tmp = day_string.split(',')
      day = tmp[0]
      parse_to_time_slices(day,tmp[1..-1])
    end
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
    @time_hash.store(day, time_hash[day.capitalize])
  end

  def find_courses_in_slices
    available_courses = {}
    courses = Course.where(:course_number => @course_tags)
    courses.each do |c|
      time_slice = (c.begin_time.to_i...c.end_time.to_i).to_a.to_set
      @time_hash.each do |k,t|
        if c.days_array.include?(k) # might be a conflict, time to check times

          class_time_range = (time_to_seconds(c.begin_time)..time_to_seconds(c.end_time)).to_a.to_set
          work_time_range = (time_to_seconds(t[0].utc)..time_to_seconds(t[1].utc)).to_a.to_set
         
          if class_time_range.subset?(work_time_range) == false
            available_courses.store(Digest::MD5.hexdigest(c.to_s), c)
            p k + " -> " + c.days_array.join(',') + " [] #{class_time_range.to_a[0]}-#{class_time_range.to_a[-1]} <=> #{work_time_range.to_a[0]}-#{work_time_range.to_a[-1]}"
          else
            p "Couldn't add course: #{c.id}"
            p k + " -> " + c.days_array.join(',') + " [] #{class_time_range.to_a[0]}-#{class_time_range.to_a[-1]} <=> #{work_time_range.to_a[0]}-#{work_time_range.to_a[-1]}"
            
          end
        else # no conflict
          available_courses.store(Digest::MD5.hexdigest(c.to_s), c)
          p k + " -> " + c.days_array.join(',') + " [#{c.id}]"          
          #print "."
        end
      end
      #p time_slice
    end
    p "#{available_courses.size}/#{courses.size} courses have been found to fit your schedule "
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
    it "should convert work_times to DateTimes" do
      work_times = []
      user_schedule = Schedule.new(user1["work_times"], user1["course_tags"])
      p user_schedule.to_s
      user_schedule.find_courses_in_slices
    end
  end

  pending "add some examples to (or delete) #{__FILE__}"

end
