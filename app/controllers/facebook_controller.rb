class FacebookController < ApplicationController
  def friends
    @user = current_user
    @friends = FbGraph::User.me(@user.authorizations.first.token).friends
  
  end
end
