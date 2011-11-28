class Friend < ActiveRecord::Base
  belongs_to :user
 
  def friend
    User.find_by_facebook_user_id(facebook_friend_id)
  end
end
