class CreateUserCourses < ActiveRecord::Migration
  def change
    create_table :user_courses do |t|
      t.string :tag
      t.integer :user_id

      t.timestamps
    end
  end
end
