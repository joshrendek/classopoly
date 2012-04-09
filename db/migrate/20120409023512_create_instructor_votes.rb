class CreateInstructorVotes < ActiveRecord::Migration
  def change
    create_table :instructor_votes do |t|
      t.integer :user_id
      t.integer :instructor_id
      t.integer :rating

      t.timestamps
    end
  end
end
