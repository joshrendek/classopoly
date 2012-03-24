class HomepageController < ApplicationController
  def index
    if current_user
      @friends = current_user.friends.collect {|f| f unless f.friend.nil? }.compact
    end
  end
end
