class RemovePictureFromFriends < ActiveRecord::Migration
  def up
    remove_column :friends, :picture
  end

  def down
  end
end
