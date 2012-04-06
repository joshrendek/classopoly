class CreateWallMessages < ActiveRecord::Migration
  def change
    create_table :wall_messages do |t|
      t.integer :user_id
      t.string :messageable_type
      t.integer :messagable_id
      t.text :content

      t.timestamps
    end
  end
end
