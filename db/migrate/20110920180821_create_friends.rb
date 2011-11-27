class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.integer :user_id
      t.integer :facebook_user_id
      t.integer :facebook_friend_id

      t.timestamps

          
        
    end
    execute "ALTER TABLE friends ALTER facebook_user_id TYPE bigint;"
    execute "ALTER TABLE friends ALTER facebook_friend_id TYPE bigint;"
    
     
  end
end
