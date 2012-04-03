module ApplicationHelper
  def facebook_avatar(id)
    image_tag "https://graph.facebook.com/#{id}/picture", :size => "24x24"
  end
end
