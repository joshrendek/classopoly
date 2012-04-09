class InstructorVotesController < ApplicationController

  before_filter :set_instructor

  def index
    render :text => @instructor.rating
  end

  def create
    @instructor.instructor_votes.build(:user => current_user, 
                                       :rating => params[:instructor_vote][:rating])
  end

  private
  def set_instructor
    @instructor = Instructor.find(params[:instructor_id])
  end
end
