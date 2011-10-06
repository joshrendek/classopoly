class Course < ActiveRecord::Base
  belongs_to :instructor
  belongs_to :college
 # Course(id: integer, course_number: string, section: string, title: string, reference_number: string, instructor_id: integer, seats: integer, seats_left: integer, building: string, room: string, begin_time: time, end_time: time, days: string, created_at: datetime, updated_at: datetime, college_id: integer, course_college_instructor_hash: string) 
  # 
  #
  
  def days_array
    arr = []
    days.split(//).each do |d|
      if d == "M" then arr << "monday" end
      if d == "T" then arr << "tuesday" end
      if d == "W" then arr << "wednesday" end
      if d == "R" then arr << "thursday" end
      if d == "F" then arr << "friday" end
    end
    arr
  end

  def self.load_courses(college, data)
    @college = college
    data.each do |d|
      begin
        if d['instructor'] != "STAFF"
          cci_hash = Digest::MD5.hexdigest(d['title'] + @college.name + d['instructor'])
          c = Course.new(:course_number => d['course_number'], :section => d['section'],
                        :reference_number => d['course_ref_num'],
                        :title => d['title'],
                        :instructor_id => Instructor.find_by_name(d['instructor']).id,
                        :seats => d['seats'].to_i, :seats_left => d['seats_left'].to_i,
                        :building => d['building'], :room => d['room'],
                        :begin_time => Course.parse_time(d['begin']), 
                        :end_time => Course.parse_time(d['end']),
                        :college_id => @college, 
                        :days => d['days'].split(' ').join(''),
                        :course_college_instructor_hash => cci_hash)
          begin
            if c.save 
              print "\n Course created: #{@college.name}: #{d['title']} taught by #{d['instructor']} [#{Instructor.find_by_name(d['instructor']).id}]".color(:green)
            end
          rescue ActiveRecord::RecordNotUnique
            print "\n Course already found: #{d['title']}".color(:red)
          end

        end
      rescue Exception => e
        print "\n Error: #{e} on #{d}".color(:red)
      end
    end
  end

  def self.parse_time(t)
    x = t.split(':')
    start = 0
    ap = x[-1].split(' ')
    if ap == "PM"
      start += 12
    end

    hour = start + x[0].to_i
    minute = ap[0]

    Time.new(2000, 1, 1, hour, minute, 0, "-05:00")
  end
end
