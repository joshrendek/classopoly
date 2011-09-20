class AuthorizationsIntToBigInt < ActiveRecord::Migration
  def up
    execute "ALTER TABLE `authorizations` CHANGE `user_id` `user_id` BIGINT(50)  NULL  DEFAULT NULL;"
  end

  def down
    execute "ALTER TABLE `authorizations` CHANGE `user_id` `user_id` INT(11)  NULL  DEFAULT NULL;"    
  end
end
