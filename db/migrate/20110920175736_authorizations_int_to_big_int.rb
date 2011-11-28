class AuthorizationsIntToBigInt < ActiveRecord::Migration
  def up
    execute "ALTER TABLE `authorizations` CHANGE `uid` `uid` BIGINT(50)  NULL  DEFAULT NULL;"
  end

  def down
    execute "ALTER TABLE `authorizations` CHANGE `uid` `uid` INT(11)  NULL  DEFAULT NULL;"    
  end
end
