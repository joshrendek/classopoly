class PreferencesController < ApplicationController
  skip_before_filter :set_preferences
  
  def index
  end
  
  def update
    logger.info '====' + current_user.id.to_s + '======'
    @pref = Preferences.find_or_create_by_user_id(current_user.id)
    render :text => 'test'
  end

end
