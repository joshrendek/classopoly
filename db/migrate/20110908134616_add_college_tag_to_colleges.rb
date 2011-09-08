class AddCollegeTagToColleges < ActiveRecord::Migration
  def change
    add_column :colleges, :college_tag, :string
  end
end
