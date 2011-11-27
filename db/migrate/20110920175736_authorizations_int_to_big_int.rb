class AuthorizationsIntToBigInt < ActiveRecord::Migration
  def up
    execute "ALTER TABLE authorizations ALTER uid TYPE bigint;"
  end

  def down
    execute "ALTER TABLE `authorizations` CHANGE `uid` `uid` INT(11)  NULL  DEFAULT NULL;"    
  end
end
