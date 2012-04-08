# require 'spec_helper'
require 'vcr'
require 'vcr_helper'
require './lib/scrapers/bookstore'
require 'hpricot'
require 'pry'

require 'spec_coverage'

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

    it "should have content in the body" do
      @book.body.should_not be_nil
    end

    it "should find an ISBN" do
      @book.isbn.should_not be_nil
      @book.isbn.should == "9780470074787"
    end
  end

end
