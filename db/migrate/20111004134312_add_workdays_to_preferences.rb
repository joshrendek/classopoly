class AddWorkdaysToPreferences < ActiveRecord::Migration
  def change
    add_column :preferences, :workdays, :string
  end
end
