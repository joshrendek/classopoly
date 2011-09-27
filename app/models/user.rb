class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_many :authorizations
  has_many :friends
  has_one :preferences
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :facebook_user_id

  def get_friends
    auth = authorizations.find_by_provider('facebook')
    user = FbGraph::User.me(auth.token)
    user.fetch.friends.each do |f|
      #p f.identifier
      begin
        friends.create(:facebook_user_id => auth.uid, :facebook_friend_id => f.identifier, :picture => f.picture)
      rescue ActiveRecord::RecordNotUnique
        p "Friend assosciation already exists between #{auth.uid} -> #{f.identifier}"
      end
    end
    nil
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    if user = User.find_by_email(data["email"])
      user
    else # Create a user with a stub password. 
      #logger.info access_token.to_yaml
      user = User.create(:email => data["email"], :password => Devise.friendly_token[0,20], 
                  :facebook_user_id => access_token['extra']['user_hash']['id'].to_i) 

      return user
    end
  end

end
