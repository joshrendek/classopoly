class Course < ActiveRecord::Base
  belongs_to :instructor
  belongs_to :college
  has_many :books
  
  def human_term
    case term[-1].to_i 
      when 9
        return "fall"
      when 1
        return "spring"
      when 6
        return "summer"
      else
        return ""
    end
  end

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

  def self.load_courses(college, data, term)
    @college = college
    data.each do |d|
      begin
        if d['instructor'] != "STAFF"
          cci_hash = Digest::MD5.hexdigest(d['title'] + @college.name + d['instructor'])
          c = Course.new(:course_number => d['course_number'], :section => d['section'],
                        :reference_number => d['course_ref_num'],
                        :title => d['title'],
                        :term => term,
                        :year => term[0..3].to_i,
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
