class FixPkOnFriends < ActiveRecord::Migration
  def up
    execute "ALTER TABLE `friends` DROP INDEX `facebook_user_id,facebook_friend_id`;"
    execute "ALTER TABLE `friends` ADD UNIQUE INDEX `user_id,facebook_friend_id` (`user_id`, `facebook_friend_id`);"
  end

  def down
  end
end
