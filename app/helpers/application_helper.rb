module ApplicationHelper
  def facebook_avatar(id)
    image_tag "https://graph.facebook.com/#{id}/picture", :size => "24x24"
  end

  def facebook_app_id
    Rails.env == "production" ? APP_CONFIG['facebook']['production']['app_id'] : APP_CONFIG['facebook']['development']['app_id']
  end
end
