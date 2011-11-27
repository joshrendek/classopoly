class AddPkToFriends < ActiveRecord::Migration
  def up
    execute "ALTER TABLE friends ADD CONSTRAINT uid_fid_key UNIQUE(facebook_user_id, facebook_friend_id);"
  end

  def down
    execute "ALTER TABLE `friends` DROP INDEX `facebook_user_id,facebook_friend_id`;"
  end
end
