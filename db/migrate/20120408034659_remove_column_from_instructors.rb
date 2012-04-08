class RemoveColumnFromInstructors < ActiveRecord::Migration
  def up
    remove_column :instructors, :college_name_hash
  end

  def down
  end
end
