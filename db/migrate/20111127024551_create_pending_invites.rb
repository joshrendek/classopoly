class CreatePendingInvites < ActiveRecord::Migration
  def change
    create_table :pending_invites do |t|
      t.integer :uid

      t.timestamps
    end

    execute "ALTER TABLE `pending_invites` CHANGE `uid` `uid` BIGINT(50)  NULL  DEFAULT NULL;"

  end
end
