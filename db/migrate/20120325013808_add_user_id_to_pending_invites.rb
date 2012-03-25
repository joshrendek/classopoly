class AddUserIdToPendingInvites < ActiveRecord::Migration
  def change
    add_column :pending_invites, :user_id, :integer
  end
end
