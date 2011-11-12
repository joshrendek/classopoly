class AddDetailsToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :semester, :string
    add_column :courses, :year, :integer
  end
end
