class AddPkToFriends < ActiveRecord::Migration
  def up
    execute "ALTER TABLE `friends` ADD UNIQUE INDEX `facebook_user_id,facebook_friend_id` (`facebook_user_id`, `facebook_friend_id`);"
  end

  def down
    execute "ALTER TABLE `friends` DROP INDEX `facebook_user_id,facebook_friend_id`;"
  end
end
