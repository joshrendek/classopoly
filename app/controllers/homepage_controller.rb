class HomepageController < ApplicationController
  def index
    if current_user
      @friends = current_user.friends.collect {|f| f unless f.friend.nil? }.compact
    end

    if params[:refid]
      PendingInvite.where(:uid => params[:refid]).destroy_all
    end
  end
end
