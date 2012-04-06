require 'spec_helper'

describe "WallMessages" do
  describe "GET /wall_messages" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get wall_messages_path
      response.status.should be(200)
    end
  end
end
