class InstructorVote < ActiveRecord::Base
  belongs_to :user 
  belongs_to :instructor 
  validates_uniqueness_of :user_id, :instructor_id,
                          :scope => 
                            [:user_id, :instructor_id]
end
