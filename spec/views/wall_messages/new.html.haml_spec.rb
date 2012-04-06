require 'spec_helper'

describe "wall_messages/new.html.haml" do
  before(:each) do
    assign(:wall_message, stub_model(WallMessage,
      :user_id => 1,
      :messageable_type => "MyString",
      :messagable_id => 1,
      :content => "MyText"
    ).as_new_record)
  end

  it "renders new wall_message form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => wall_messages_path, :method => "post" do
      assert_select "input#wall_message_user_id", :name => "wall_message[user_id]"
      assert_select "input#wall_message_messageable_type", :name => "wall_message[messageable_type]"
      assert_select "input#wall_message_messagable_id", :name => "wall_message[messagable_id]"
      assert_select "textarea#wall_message_content", :name => "wall_message[content]"
    end
  end
end
