class Scheduler
  DEBUG = true
  require 'set'
  require 'digest/md5'  
  attr_accessor :time_hash, :course_tags, :available_courses, :courses

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

  def time_to_seconds(time)
    time.hour * 60 * 60 + time.min * 60 
  end

  def get_courses
    @available_courses.collect {|k,v| v }
  end

  def parse_to_time_slices(day, times)
    date = Date.parse(day)
    date_at_beginning_of_month = first_weekday_at_beginning_of_month(date)
    times_at_beginning_of_month = times.map do |time_string|
      add_time_to_date(date_at_beginning_of_month, time_string)
    end
    @time_hash.store(day, times_at_beginning_of_month)
  end

  def add_time_to_date(date, time)
    hour_count, minute_count = time.split(':')
    date.to_time + hour_count.to_i.hours + minute_count.to_i.minutes
  end

  def first_weekday_at_beginning_of_month(date)
    (Date.today.beginning_of_month + (date.wday - Date.today.beginning_of_month.wday) % 7)
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
        
        p "Class time: #{class_time_range.first} -> #{class_time_range.to_a.last}"
        p "Work time: #{work_time_range.first} -> #{work_time_range.to_a.last}"

        #p "Local time: #{t[0].localtime} #{t[1].localtime}" if DEBUG
        #p "Work time: #{work_time_range.to_a[0]} #{work_time_range.to_a[-1]}" if DEBUG
        #p "Time hash time: #{time_to_seconds(t[0].localtime)} #{time_to_seconds(t[1].localtime)}" if DEBUG
        p "_"*60 if DEBUG

        # if the class time isnt a subset of the work time, we can add it to the available courses hash
        if class_time_range.subset?(work_time_range) == false
          # store the crouse inside the available_courses hash with Course.to_s MD5'd as a key
          available_courses.store(Digest::MD5.hexdigest(c.to_s), c)
          
          p "Added course: #{c.id}" if DEBUG
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


