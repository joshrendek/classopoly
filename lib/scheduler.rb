class Scheduler
  require 'set'
  TimeKeeper = Struct.new(:day, :start, :end)
  CourseTime = Struct.new(:id, :start, :end, :days)
  attr_accessor :occupied_time, :course_times, :available_courses

  def initialize(work_times, course_list)
    @occupied_time = []
    @work_times = work_times
    @course_list = course_list
    @course_times = []
    @available_courses = []

    parse_work_times_to_array
    build_course_times

  end

  # before calling this you can still use course_time_exists_in_occupied_time?
  # after calling this the class will now exist in occupied TimeKeeper
  # and the course_time_exists_in_occupied_time? method will fail
  def build
    build_available_courses
  end

  def build_available_courses
    @course_times.each do |c|
      if !course_time_exists_in_occupied_time?(c)
        @available_courses << c
        c.days.split(//).each do |day|
          @occupied_time << TimeKeeper.new(day.upcase, c.start, c.end)
        end
      end
    end
  end

  def course_time_exists_in_occupied_time?(course_time)
    exists = false
    @occupied_time.each do |ot|

      b1 = course_time.end > ot.start
      b2 = course_time.start < ot.end
      b3 = course_time.days.include?(ot.day)

      if b2 && b1 && b3
        exists = true
        break
      end

      if !b3 && b1 && b2
        # break
      end
    end
    exists
  end

  def parse_work_times_to_array
    @work_times.each do |t|
      time = t.split(",")
      t_start = time[1].split(':')
      t_end = time[2].split(':')
      start_time = t_start[0].to_i*60*60 + t_start[1].to_i*60
      end_time = t_end[0].to_i*60*60 + t_end[1].to_i*60


      @occupied_time  << TimeKeeper.new(t[0].upcase, start_time, end_time)

    end
  end

  def build_course_times
    @course_list.each do |c|
      start_time = c.begin_time.hour*60*60 + c.begin_time.min*60
      end_time = c.end_time.hour*60*60 + c.end_time.min*60
      @course_times << CourseTime.new(c.id, start_time, end_time, c.days)
    end
  end

end
