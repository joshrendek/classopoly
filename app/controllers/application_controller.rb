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

  def require_login!
    if !current_user
      flash[:message] = "You need to login first with facebook!"
      redirect_to root_path
    end
  end

end
