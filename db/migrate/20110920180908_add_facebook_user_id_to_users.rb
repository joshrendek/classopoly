class AddFacebookUserIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_user_id, :integer
    execute "ALTER TABLE users ALTER facebook_user_id TYPE bigint;"
  end
end
