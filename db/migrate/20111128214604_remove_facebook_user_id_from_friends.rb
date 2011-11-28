class RemoveFacebookUserIdFromFriends < ActiveRecord::Migration
  def up
    remove_column :friends, :facebook_user_id
  end

  def down
  end
end
