require "spec_helper"

describe WallMessagesController do
  describe "routing" do

    it "routes to #index" do
      get("/wall_messages").should route_to("wall_messages#index")
    end

    it "routes to #new" do
      get("/wall_messages/new").should route_to("wall_messages#new")
    end

    it "routes to #show" do
      get("/wall_messages/1").should route_to("wall_messages#show", :id => "1")
    end

    it "routes to #edit" do
      get("/wall_messages/1/edit").should route_to("wall_messages#edit", :id => "1")
    end

    it "routes to #create" do
      post("/wall_messages").should route_to("wall_messages#create")
    end

    it "routes to #update" do
      put("/wall_messages/1").should route_to("wall_messages#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/wall_messages/1").should route_to("wall_messages#destroy", :id => "1")
    end

  end
end
