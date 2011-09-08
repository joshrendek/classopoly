class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :course_number
      t.string :section
      t.string :title
      t.string :reference_number
      t.integer :instructor_id
      t.integer :seats
      t.integer :seats_left
      t.string :building
      t.string :room
      t.time :begin_time
      t.time :end_time
      t.string :days

      t.timestamps
    end
  end
end
