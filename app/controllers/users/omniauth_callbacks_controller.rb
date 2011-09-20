class Users::OmniauthCallbacksController < ApplicationController
 def facebook
   @user = User.find_for_facebook_oauth(env["omniauth.auth"], current_user)
   hash = env["omniauth.auth"]

   begin
     auth = Authorization.create!(:user_id => @user,
                                :uid =>      hash['uid'],
                                :provider => hash['provider'],
                                :token =>    hash['credentials']['token'])

   rescue ActiveRecord::RecordInvalid
     auth = Authorization.find_by_user_id(@user)
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
