require 'spec_lite'
require './app/models/instructor'
require './app/models/college'
require 'pry'

describe Instructor do
  before(:each) do 
    Instructor.destroy_all
    @classes = [{"course_number"=>"ACG3101",
      "section"=>"01",
      "course_ref_num"=>"00003",
      "summer"=>"B",
      "title"=>"FIN ACTG & REP I",
      "instructor"=>"Heflin, Frank L",
      "seats"=>"35",
      "seats_left"=>"12",
      "building"=>"RBA",
      "room"=>"0104",
      "days"=>"MTWR",
      "begin"=>"03:30 PM",
      "end"=>"05:05 PM"}]

    @college = double('college')
    @college.stub(:name => "FSU")
    @college.stub(:to_i).and_return(1)
  end
  context "Loading instructors from an import" do
    it "should create a record for a new instructor" do 
      Instructor.all.count.should eq(0)
      Instructor.load_instructors(@college, @classes)
      Instructor.all.count.should eq(1)
    end

    it "should not create duplicate records" do 
      Instructor.all.count.should eq(0)
      Instructor.load_instructors(@college, @classes)
      Instructor.load_instructors(@college, @classes)
      Instructor.all.count.should eq(1)
    end
  end
end
