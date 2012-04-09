class InstructorVotesController < ApplicationController

  before_filter :set_instructor

  def index
    ratings = @instructor.instructor_votes.values_of(:rating).sum.to_f/@instructor.instructor_votes.count.to_f
    render :text => ratings.nan? ? 'No rating' : ratings
  end

  def create
    @vote = @instructor.instructor_votes.build(:user => current_user, 
                                       :rating => params[:instructor_vote][:rating])
    @vote.save 
    render :text => "OK" and return
  end

  private
  def set_instructor
    @instructor = Instructor.find(params[:instructor_id])
  end
end
