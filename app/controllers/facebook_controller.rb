class FacebookController < ApplicationController
  before_filter :require_login!
  def friends
    @user = current_user
    @friends = FbGraph::User.me(@user.authorizations.first.token).friends
  
  end

  def invite
    PendingInvite.create(:uid => params[:uid])
    render :text => "OK", :status => :ok 
  end
end
