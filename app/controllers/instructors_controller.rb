class InstructorsController < ApplicationController
  layout 'sidebar_layout'
  def show
    @instructor = Instructor.find(params[:id])
    @wall_message = WallMessage.new
    @type = @instructor


  end
end 

