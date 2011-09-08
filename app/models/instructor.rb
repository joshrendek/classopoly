class Instructor < ActiveRecord::Base
  has_many :courses

  def self.load_instructors(college, data)
    require 'digest/md5'    
    @college = college

    data.each do |d|
      begin
        if d['instructor'] != "STAFF"
          x = d['instructor' ].split(',')
          cn_hash = Digest::MD5.hexdigest(@college.name + d['instructor'])
          i = Instructor.new(:name => d['instructor'],
                             :college_id => college, 
                             :last_name => x[0], 
                             :college_name_hash => cn_hash)
          begin
            if i.save 
              print "\nInstructor created: #{@college.name}: #{d['instructor']}".color(:green)
            end
          rescue ActiveRecord::RecordNotUnique
            print "\n Instructor already found: #{d['instructor']}".color(:red)
          end

        end
      rescue Exception => e
        print "\n Error: #{e} on #{d}".color(:red)
      end
    end

  end

end
