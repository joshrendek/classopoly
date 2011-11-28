class AddFacebookUserIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_user_id, :integer
    execute "ALTER TABLE `users` CHANGE `facebook_user_id` `facebook_user_id` BIGINT(50)  NULL  DEFAULT NULL;"
  end
end
