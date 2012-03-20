# require 'spec_helper'
require 'spec_lite'
require './app/models/book'
require './app/models/course'

describe Book do
  before(:each) do
    @course = double('course')
    @course.stub(:id => 1)
  end
  context "A Book should belong to a course" do
    it "should have a course" do
      book = Book.create(:isbn => "123", :course_id => @course.id)
      book.course_id.should ==  @course.id
      book.course_id.should_not be_nil
    end

    it "should not allow a book to be created without a course" do
      book = Book.create(:isbn => "123")
      expect { book.save! }.should raise_error
      
    end
  end
end
