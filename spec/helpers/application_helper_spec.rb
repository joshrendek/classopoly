require 'spec_helper' 
require 'spec_coverage'

describe ApplicationHelper do 
  include ActionView::Helpers::AssetTagHelper
  include ApplicationHelper

  it "should give me the image to a facebook profile image" do 
    i = facebook_avatar(1)
    i.should == '<img alt="Picture" height="24" src="https://graph.facebook.com/1/picture" width="24" />'

  end

  it "should give me the appropriate facebook application id" do
    facebook_app_id.should_not be_nil 
  end

end
