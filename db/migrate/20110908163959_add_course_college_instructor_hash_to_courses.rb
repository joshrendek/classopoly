class AddCourseCollegeInstructorHashToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :course_college_instructor_hash, :string, :null => false
    add_index :courses, :course_college_instructor_hash, :unique => true
    
  end
end
