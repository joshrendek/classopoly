require 'vcr'
require 'vcr_helper'
require './lib/isbndb'
require 'hpricot'
require 'pry'

require 'yaml'
require './config/initializers/app_config'

describe ISBN::API::Price do

  before(:all) do 
    VCR.use_cassette('isbn') do 
      @book = ISBN::API::Price.new('9780470074787')
    end
  end

  context "Get book prices via ISBNdb.com API for 9780470074787" do
    it "should fetch the prices" do
      @book.prices.count.should > 5
    end

    it "should get the min price" do
      @book.min.should_not be_nil
    end

    it "should get the max price" do
      @book.max.should_not be_nil
    end

    it "should get the average price" do
      @book.average.should_not be_nil
    end

  end

end
