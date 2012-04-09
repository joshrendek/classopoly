class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
 
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_many :authorizations
  has_many :friends
  has_one :preferences
  has_many :user_courses
  has_many :courses, :through => :user_courses
  has_many :pending_invites
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :facebook_user_id, :name, :link, :gender

  def voted_for_instructor?(instructor)
    v = InstructorVote.where(:user_id => id, :instructor_id => instructor.id)

    v.count > 0 ? true : false
  end

  def safe_name
    tmp = name.split(" ")
    [tmp[0], tmp[1][0]].join(" " ) + "."
  end

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

  def self.friend_ids_to_names(friend_ids)
    friend_ids.collect do |f|
      Friend.find_by_facebook_friend_id(User.find(f).facebook_user_id).try(:name)
    end  
  end

  def find_friends_in_course(course_id)
    fbid = facebook_user_id
    friends = Friend.where(:facebook_friend_id => fbid).where("user_id != ?", id).collect {|f| f.user }.compact
    friend_ids = []
    friends.each do |f|
      fc = f.courses.where(:id => course_id)
      if fc.count == 1
        friend_ids << f.id
      end
    end
    friend_ids
  end

  def courses_with_friends
    friend_courses = find_friends_courses.collect {|c| c.id }
    my_courses = self.courses.collect {|c| c.id }
    Course.where(:id => (friend_courses & my_courses))
  end

  def find_friends_courses
    fbid = facebook_user_id
    friends = Friend.where(:facebook_friend_id => fbid).where("user_id != ?", id).collect {|f| f.user } 
    friends.collect {|f| f.courses }.flatten
  end

  def facebook 
    token = self.authorizations.where(:provider => 'facebook').first.token
    FbGraph::User.me(token)
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    if user = User.find_by_email(data["email"])
      user
    else # Create a user with a stub password. 
      #logger.info access_token.to_yaml
# binding.pry

      user = User.create(:email => data["email"], :password => Devise.friendly_token[0,20], 
                  :facebook_user_id => access_token['extra']['user_hash']['id'].to_i,
                  :name => access_token['extra']['user_hash']['name'], :link => access_token['extra']['user_hash']['link'],
                  :gender => access_token['extra']['user_hash']['gender']) 

      return user
    end
  end

end
