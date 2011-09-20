class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.integer :user_id
      t.integer :uid
      t.string :provider
      t.string :token

      t.timestamps
    end
  end
end
