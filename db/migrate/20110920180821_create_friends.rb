class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.integer :user_id
      t.integer :facebook_user_id
      t.integer :facebook_friend_id

      t.timestamps

          
        
    end
      execute "ALTER TABLE `friends` CHANGE `facebook_user_id` `facebook_user_id` BIGINT(50)  NULL  DEFAULT NULL;"
      execute "ALTER TABLE `friends` CHANGE `facebook_friend_id` `facebook_friend_id` BIGINT(50)  NULL  DEFAULT NULL;"

  end
end
