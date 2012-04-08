class Instructor < ActiveRecord::Base
  has_many :courses
  has_many :wall_messages, :as => :message

  validates_uniqueness_of :name, :college_id,
                          :scope => 
                            [:name, :college_id]



  def self.load_instructors(college, data)
    require 'digest/md5'    
    @college = college

    data.each do |d|
        if d['instructor'] != "STAFF"
          x = d['instructor' ].split(',')
          i = Instructor.new(:name => d['instructor'],
                             :college_id => college, 
                             :last_name => x[0])
                             
          if i.save 
            print "\nInstructor created: #{@college.name}: #{d['instructor']}"
          else

            print "\n Instructor already found: #{d['instructor']}"
          end

        end
    end

  end

end
