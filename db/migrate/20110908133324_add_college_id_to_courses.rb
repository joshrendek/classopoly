class AddCollegeIdToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :college_id, :integer
  end
end
