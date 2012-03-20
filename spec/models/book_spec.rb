require 'spec_helper'

# require 'active_record'
# require 'active_model'
# require './app/models/book'
# require './app/models/course'
# require 'pry'



describe Book do
  before(:each) do
    @course = double('course')
    @course.stub(:id => 1)
  end
  context "A Book should belong to a course" do
    it "should have a course" do
      book = Book.create(:isbn => "123", :price => 5, :course_id => @course.id)
      book.course_id.should ==  @course.id
      book.course_id.should_not be_nil
    end

    it "should not allow a book to be created without a course" do
      book = Book.new(:isbn => "123", :price => 5)
      expect { book.save! }.should raise_error
      
    end
  end
end
