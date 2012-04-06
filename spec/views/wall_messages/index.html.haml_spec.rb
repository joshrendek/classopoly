require 'spec_helper'

describe "wall_messages/index.html.haml" do
  before(:each) do
    assign(:wall_messages, [
      stub_model(WallMessage,
        :user_id => 1,
        :messageable_type => "Messageable Type",
        :messagable_id => 1,
        :content => "MyText"
      ),
      stub_model(WallMessage,
        :user_id => 1,
        :messageable_type => "Messageable Type",
        :messagable_id => 1,
        :content => "MyText"
      )
    ])
  end

  it "renders a list of wall_messages" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Messageable Type".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
