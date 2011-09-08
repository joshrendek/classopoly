class CreateInstructors < ActiveRecord::Migration
  def change
    create_table :instructors do |t|
      t.string :name
      t.integer :college_id

      t.timestamps
    end
  end
end
