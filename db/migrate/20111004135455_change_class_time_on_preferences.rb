class ChangeClassTimeOnPreferences < ActiveRecord::Migration
  def up
    change_column(:preferences, :class_time, :string)
  end

  def down
    change_column(:preferences, :class_time, :integer)
  end
end
