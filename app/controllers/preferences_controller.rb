class PreferencesController < ApplicationController
  skip_before_filter :set_preferences
  
  def index
  end
  
  def update
    @pref = current_user.preferences.find_or_create_by_user_id(current_user)
  end

end
