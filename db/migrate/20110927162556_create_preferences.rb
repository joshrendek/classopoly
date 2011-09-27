class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.integer :user_id
      t.integer :class_time
      t.time :lunch_time

      t.timestamps
    end
  end
end
