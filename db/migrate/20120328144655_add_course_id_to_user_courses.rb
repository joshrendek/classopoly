class AddCourseIdToUserCourses < ActiveRecord::Migration
  def change
    add_column :user_courses, :course_id, :integer
    remove_column :user_courses, :tag
  end
end
