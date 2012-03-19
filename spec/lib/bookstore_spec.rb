require 'spec_helper'

describe Bookstore do

  before(:all) do 
      @book = Bookstore::Fetch.new({:year => 2012, :term => 1, :refnum =>"06526"})
  end
  context "Fetch a isbn" do
    it "should get 200 OK response" do
     @book.response.code.should == "200"
    end

    it "should find an ISBN" do
      @book.isbn.should_not be_nil
    end
  end

end
