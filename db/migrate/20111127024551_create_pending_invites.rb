class CreatePendingInvites < ActiveRecord::Migration
  def change
    create_table :pending_invites do |t|
      t.integer :uid

      t.timestamps
    end
    execute "ALTER TABLE pending_invites ALTER uid TYPE bigint;"
  end
end
