class Authorization < ActiveRecord::Base
  validates_uniqueness_of :user_id
  attr_accessible :user_id, :token, :provider, :uid
end
