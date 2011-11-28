class FacebookController < ApplicationController
  before_filter :require_login!
  def friends
    @user = current_user
    friends = FbGraph::User.me(@user.authorizations.first.token).friends
    friends.each do |f|
      begin
        current_user.friends.create(:facebook_friend_id => f.identifier, :name => f.name)
      rescue ActiveRecord::RecordNotUnique
        #skip
      end
    end
    @friends = current_user.friends
  
  end

  def invite
    PendingInvite.create(:uid => params[:uid])
    render :text => "OK", :status => :ok 
  end
end
