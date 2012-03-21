class Scheduler
  DEBUG = TRUE
  require 'set'
  require 'digest/md5'  
  require 'logger'
  attr_accessor :time_hash, :course_tags, :available_courses, :courses, :unavailable_courses

  def initialize(work_times, tag, course_list)
    if DEBUG
      @logger = Logger.new(STDOUT)
    end
    @time_hash = {}
    @course_list = course_list
    @course_tags = tag
    @available_courses = {}
    @unavailable_courses = {}
    work_times.split('|').each do |day_string|
      tmp = day_string.split(',')
      day = tmp[0]
      parse_to_time_slices(day,tmp[1..-1])
    end
  end

  def day_to_abbrev(day)
    day =~ /thursday/ ? 'R' : day[0].upcase
  end

  def time_to_seconds(time)
    time.hour * 60 * 60 + time.min * 60 
  end

  def get_courses
    @available_courses.collect {|k,v| v }
  end

  def get_unavailable_courses
    @unavailable_courses.collect {|k,v| v }
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
    p time
    hour_count, minute_count = time.split(':')
    #p date.to_time.utc + hour_count.to_i.hours + minute_count.to_i.minutes
    #date.to_time.utc + hour_count.to_i.hours + minute_count.to_i.minutes
    DateTime.new(date.year, date.month, date.day, hour_count.to_i, minute_count.to_i)
  end

  def first_weekday_at_beginning_of_month(date)
    (Date.today.beginning_of_month + (date.wday - Date.today.beginning_of_month.wday) % 7)
  end

  def find_courses_in_slices
    available_courses = {}
    unavailable_courses = {}

    p @time_hash
    # find all courses that include the course tags they're enrolled in
    @courses = @course_list
    @courses.each do |c|
      # turn the time of the class into a time set  
      time_slice = (c.begin_time.localtime.to_i...c.end_time.localtime.to_i).to_a.to_set
      # loop through each time slice from when they work
      @time_hash.each do |k,t|
        p "_"*60 if DEBUG
        @logger.info "K: #{k}" 
        @logger.info @available_courses.size
        @logger.info @unavailable_courses.size
        # might be a conflict if the class is on the same day they work, time to check times
        # create two time sets for class and work 
        begin_time = DateTime.new(t[0].year, t[0].month, t[0].day, c.begin_time.utc.hour, c.begin_time.utc.min)
        end_time = DateTime.new(t[0].year, t[0].month, t[0].day, c.end_time.utc.hour, c.end_time.utc.min)
        class_time_range = (time_to_seconds(begin_time)..time_to_seconds(end_time)).to_a.to_set
        work_time_range = (time_to_seconds(t[0].utc)..time_to_seconds(t[1].utc)).to_a.to_set
        
        # p begin_time.utc
        # p end_time.utc
        # p t[0].utc
        # p t[1].utc
         
        @logger.info "Class time: #{class_time_range.first} -> #{class_time_range.to_a.last}"
        @logger.info "Work time: #{work_time_range.first} -> #{work_time_range.to_a.last}"

          #p "Local time: #{t[0].localtime} #{t[1].localtime}" if DEBUG
          #p "Work time: #{work_time_range.to_a[0]} #{work_time_range.to_a[-1]}" if DEBUG
          #p "Time hash time: #{time_to_seconds(t[0].localtime)} #{time_to_seconds(t[1].localtime)}" if DEBUG


          # if the class time isnt a subset of the work time, we can add it to the available courses hash
          if class_time_range.subset?(work_time_range) == false && !c.days.include?(day_to_abbrev(k))
            # store the crouse inside the available_courses hash with Course.to_s MD5'd as a key

            # if it was unavailable previously its not available here
            if !@unavailable_courses.has_key?(Digest::MD5.hexdigest(c.to_s))
              @logger.info "Storing course #{c.id}"
              @available_courses.store(Digest::MD5.hexdigest(c.to_s), c.id) # only story course id
            end
              
            p "Added course: #{c.id}" if DEBUG
            p k + " -> " + c.days_array.join(',') + " [] #{class_time_range.to_a[0]}-#{class_time_range.to_a[-1]} <=> #{work_time_range.to_a[0]}-#{work_time_range.to_a[-1]}" if DEBUG

          else
            @unavailable_courses.store(Digest::MD5.hexdigest(c.to_s), c)
            p "Couldn't add course: #{c.id}" if DEBUG
            print "\t" + k + " -> " + c.days_array.join(',') + " [] #{class_time_range.to_a[0]}-#{class_time_range.to_a[-1]} <=> #{work_time_range.to_a[0]}-#{work_time_range.to_a[-1]}\n" if DEBUG

          end
      end 
      

    end
    @logger.info "#{@available_courses.size}/#{@courses.size} courses have been found to fit your schedule " if DEBUG
       p "="*60 if DEBUG
  end

  def to_s
    @time_hash.each do |d|
      p d
    end
    return
  end
end


