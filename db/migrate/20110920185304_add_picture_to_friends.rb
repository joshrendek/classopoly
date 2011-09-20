class AddPictureToFriends < ActiveRecord::Migration
  def change
    add_column :friends, :picture, :string
  end
end
