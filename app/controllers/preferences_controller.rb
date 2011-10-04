class PreferencesController < ApplicationController
  skip_before_filter :set_preferences
  
  def index
  end
  
  def update
    logger.info '====' + current_user.id.to_s + '======'
    @pref = Preferences.find_or_create_by_user_id(current_user.id)
    @pref.update_attributes(:class_time => params[:class_time], :lunch_time => params[:lunch_time], :workdays => params[:work_times])
    render :text => 'test'
  end

end
