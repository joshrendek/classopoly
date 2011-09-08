class AddLastNameToInstructors < ActiveRecord::Migration
  def change
    add_column :instructors, :last_name, :string
  end
end
