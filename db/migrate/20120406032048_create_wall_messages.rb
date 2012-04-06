class CreateWallMessages < ActiveRecord::Migration
  def change
    create_table :wall_messages do |t|
      t.integer :user_id
      t.string :messagee_type
      t.integer :message_id
      t.text :content

      t.timestamps
    end
  end
end
