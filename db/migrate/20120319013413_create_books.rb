class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.integer :course_id
      t.string :isbn
      t.float :price

      t.timestamps
    end
  end
end
