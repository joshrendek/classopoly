class UserCoursesController < ApplicationController

  def generate_course_list
    # u = Scheduler.new("monday,00:01,1:00", ['COP3014', 'COP3252']); u.find_courses_in_slices; u.get_courses
    builder = Scheduler.new(current_user.preferences.workdays, current_user.user_courses.collect {|uc| uc.tag })
    builder.find_courses_in_slices
    @courses = builder.get_courses
    @unavailable_courses = builder.get_unavailable_courses
  end

  # GET /user_courses
  # GET /user_courses.json
  def index
    @user_courses = UserCourse.all

    respond_to do |format|
      format.html # index.html.haml
      format.json { render json: @user_courses }
    end
  end

  # GET /user_courses/1
  # GET /user_courses/1.json
  def show
    @user_course = UserCourse.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_course }
    end
  end

  # GET /user_courses/new
  # GET /user_courses/new.json
  def new
    @user_course = current_user.user_courses.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_course }
    end
  end

  # GET /user_courses/1/edit
  def edit
    @user_course = UserCourse.find(params[:id])
  end

  # POST /user_courses
  # POST /user_courses.json
  def create
    @user_course = current_user.user_courses.build(params[:user_course])


      if @user_course.save
        redirect_to user_courses_path
      else
        render action: "new"
      end

  end

  # PUT /user_courses/1
  # PUT /user_courses/1.json
  def update
    @user_course = UserCourse.find(params[:id])

    respond_to do |format|
      if @user_course.update_attributes(params[:user_course])
        format.html { redirect_to @user_course, notice: 'User course was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_courses/1
  # DELETE /user_courses/1.json
  def destroy
    @user_course = UserCourse.find(params[:id])
    @user_course.destroy

    respond_to do |format|
      format.html { redirect_to user_courses_url }
      format.json { head :ok }
    end
  end
end
