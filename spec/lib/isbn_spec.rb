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

  context "Get book prices via ISBNdb.com API" do
    it "should fetch the price for 9780470074787" do
      p @book.price
    end
  end
end
