require 'spec_helper'

describe "wall_messages/show.html.haml" do
  before(:each) do
    @wall_message = assign(:wall_message, stub_model(WallMessage,
      :user_id => 1,
      :messageable_type => "Messageable Type",
      :messagable_id => 1,
      :content => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Messageable Type/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
  end
end
