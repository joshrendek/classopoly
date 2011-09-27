class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_preferences


  def set_preferences
    if current_user
      if current_user.preferences.nil?
        flash[:message] = "You need to pick some preferences first"
        redirect_to preferences_path
      end
    end
  end
end
