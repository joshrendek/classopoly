class AddTermToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :term, :string
    remove_column :courses, :semester
  end
end
