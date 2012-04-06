class WallMessagesController < ApplicationController
  layout nil
  before_filter :set_obj_type

  def index
    @wall_messages = @type.wall_messages.order("id desc").limit(50)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @wall_messages }
    end
  end

  def show
    @wall_message = WallMessage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @wall_message }
    end
  end

  def new
    @wall_message = WallMessage.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @wall_message }
    end
  end

  def edit
    @wall_message = WallMessage.find(params[:id])
  end

  def create
    @wall_message = WallMessage.new(params[:wall_message])
    @wall_message.user = current_user


    @wall_message.message = @type

    respond_to do |format|
      if @wall_message.save
        format.html { redirect_to @type, notice: 'Wall message was successfully created.' }
        format.json { render json: @wall_message, status: :created, location: @wall_message }
      else
        format.html { render action: "new" }
        format.json { render json: @wall_message.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @wall_message = WallMessage.find(params[:id])

    respond_to do |format|
      if @wall_message.update_attributes(params[:wall_message])
        format.html { redirect_to @wall_message, notice: 'Wall message was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @wall_message.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @wall_message = WallMessage.find(params[:id])
    @wall_message.destroy

    respond_to do |format|
      format.html { redirect_to wall_messages_url }
      format.json { head :ok }
    end
  end

  private
  def set_obj_type
    if params[:course_id]
      @type = Course.find(params[:course_id])
    elsif params[:instructor_id]
      @type = Instructor.find(params[:instructor_id])
    end
  end
end
