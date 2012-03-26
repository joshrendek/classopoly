require 'vcr'
require 'vcr_helper'
require 'spec_lite'
require './lib/college_importer'
require './app/models/college'
require './app/models/course'
require 'hpricot'
require 'pry'

describe CollegeImporter do
  before(:each) do 
    @importer = CollegeImporter::FSU::Import.new
  end
  context "FSU" do
    it "should set the cookies" do
      VCR.use_cassette('importer_fsu_cookie') do
        @importer.cookie.should be_nil
        @importer.get_cookies
        @importer.cookie.should_not be_nil
      end
    end

    it "should find all departments" do
      VCR.use_cassette('importer_fsu_cookie') do
        @importer.get_cookies
        @importer.departments.should be_empty
        @importer.get_all_departments
        @importer.departments.size.should > 1
      end
    end

    it "should parse a department" do
      VCR.use_cassette('importer_fsu_cookie') do
        @importer.get_cookies
        @importer.get_all_departments
      end

      VCR.use_cassette('fsu_departments') do
        response = @importer.fetch_department(@importer.departments.first)
        @importer.parse_dept_html(response)
        @importer.classes.size.should eq(43)
      end

    end

  end
end

