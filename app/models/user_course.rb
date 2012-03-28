class UserCourse < ActiveRecord::Base
  belongs_to :user
  belongs_to :course

  validates_uniqueness_of :user_id, :course_id,
                          :scope => 
                            [:user_id, :course_id]

end
