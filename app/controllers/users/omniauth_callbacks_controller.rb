class Users::OmniauthCallbacksController < ApplicationController
 def facebook
   @user = User.find_for_facebook_oauth(env["omniauth.auth"], current_user)
   hash = env["omniauth.auth"]
   auth = Authorization.where(:user_id => @user.id).first
   logger.info "=== #{@user.to_yaml} ==="
   logger.info "=== #{auth.to_yaml} ==="

   if auth.nil?
     auth = Authorization.create!(:user_id => @user.id,
                                  :uid =>      hash['uid'],
                                  :provider => hash['provider'],
                                  :token =>    hash['credentials']['token'])

   else
     auth = Authorization.where(:user_id => @user.id).first
     auth.uid = hash['uid']
     auth.provider = hash['provider']
     auth.token = hash['credentials']['token']
     auth.save!
   
   end

   if @user.persisted?
     flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
     sign_in_and_redirect @user, :event => :authentication
   else
     session["devise.facebook_data"] = env["omniauth.auth"]
     redirect_to new_user_registration_url
   end
 end
end
