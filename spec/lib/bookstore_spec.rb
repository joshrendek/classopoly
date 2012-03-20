# require 'spec_helper'
require 'vcr'
require 'vcr_helper'
require './lib/scrapers/bookstore'
require 'hpricot'

describe Bookstore do

  before(:all) do 
    VCR.use_cassette('fsu_isbn') do 
      @book = Bookstore::Fetch.new({:year => 2012, :term => 1, :refnum =>"06526"})
    end
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
