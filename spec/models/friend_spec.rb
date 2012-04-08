require 'spec_lite'
require 'devise'
require './config/initializers/app_config'
require './config/initializers/devise'
require './app/models/friend'
require './app/models/user'
require 'pry'
# 
# require 'spec_helper'

describe Friend do
  # include Devise::TestHelpers
  before(:each) do 
    User.new(:facebook_user_id => 1, :email => "foo@bar.com", 
            :password => "foo123", :password_confirmation => "foo123").save
  end
  context "a friend's user" do 

    it "should find a user given a friend id" do 
      f = Friend.create(:facebook_friend_id => 1)
      f.friend.should_not be_nil
    end

    it "should not find a friend if the user doesn't exist" do
      f = Friend.create(:facebook_friend_id => 2)
      f.friend.should be_nil
    end

  end
end
