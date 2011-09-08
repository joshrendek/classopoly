class Instructor < ActiveRecord::Base

  def self.load_instructors(college, data)
    @college = college

    data.each do |d|
      p d['instructor']

    end
    
  end

end
