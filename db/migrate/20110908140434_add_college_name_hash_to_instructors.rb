class AddCollegeNameHashToInstructors < ActiveRecord::Migration
  def change
    add_column :instructors, :college_name_hash, :string, :null => false
    add_index :instructors, :college_name_hash, :unique => true
  end
end
