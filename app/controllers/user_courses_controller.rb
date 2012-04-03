class UserCoursesController < ApplicationController
  before_filter :require_login!

  DatatableFields = ["remove", "course_number", "section", "title","instructor", 
                     "seats_left", "seats", "building", "room", "begin_time",
                     "end_time", "days", "college", "friends"]
  GeneratedList = ["course_number", "section", "title","instructor", 
                     "seats_left", "seats", "building", "room", "begin_time",
                     "end_time", "days", "college", "friends"]

  def generate_course_list
    # u = Scheduler.new("monday,00:01,1:00", ['COP3014', 'COP3252']); u.find_courses_in_slices; u.get_courses
    # builder = Scheduler.new(current_user.preferences.workdays, current_user.user_courses.collect {|uc| uc.tag })
    # builder.find_courses_in_slices
    respond_to do |f|
      f.html
      f.json { 
        s = Scheduler.new(current_user.preferences.workdays.split("|"), current_user.courses)
        s.build

        available_course_ids = s.available_courses.collect {|c| c.id }
        @courses = Course.where(:id => available_course_ids)
        json = DatatablesRails::Structify.new(@courses)
        json.formatter do |u|
          course = Course.find(u['id'])
          u['begin_time'] = u['begin_time'].localtime.strftime("%I:%M %p")
          u['end_time'] = u['end_time'].localtime.strftime("%I:%M %p")
          u['instructor'] = course.try(:instructor).try(:name)
          u['college'] = course.college.college_tag.upcase
          u['friends'] = User.friend_ids_to_names( current_user.find_friends_in_course(u['id']) )
        end
        render :json => json.struct
      }

    end
    # @unavailable_courses = builder.get_unavailable_courses
  end

  # GET /user_courses
  # GET /user_courses.json
  def index
    @user_courses = current_user.user_courses
    @courses = current_user.courses
    respond_to do |format|
      format.html # index.html.haml
      format.json { 

        page = 1

        page = params[:iDisplayStart].to_i/10+1 if params[:iDisplayStart]
        e = @courses
        e = e.joins(:instructor, :college)

        total_record_size = 0
        display_length = 10

        if params[:iDisplayLength].to_i > 10
          display_length = params[:iDisplayLength].to_i
        end

        if params[:iSortCol_0].to_i != 0
          sort_column = DatatableFields[params[:iSortCol_0].to_i]
          sort_direction = params[:sSortDir_0]
          if ["instructor", "college"].include?(sort_column)
            sc = ""
            case sort_column
            when /instructor/
              sc = "instructors.name"
            when /college/
              sc = "colleges.college_tag"
            end
            e = e.order("#{sc} #{sort_direction}")
          else
            e = e.order("#{sort_column} #{sort_direction}")
          end
        end


        if params[:sSearch] != "" && !params[:sSearch].nil?

          search = DatatableFields.collect{|d| "#{d} LIKE '%#{params[:sSearch]}%'" unless ["college","instructor", "add"].include?(d) }.compact.join(' OR ')
          search2 = " OR instructors.name LIKE '%SUB%' OR colleges.college_tag LIKE '%SUB%' ".gsub('SUB', params[:sSearch])
          search += search2

          e = e.where(search)
          total_record_size = e.count
          e = e.page page
          #logger.info "EQ: " + e.to_sql
        else
          total_record_size = e.count
          e = e.page page
        end


        json = DatatablesRails::Structify.new(e)

        json.formatter do |u|
          course = Course.find(u['id'])
          ucourse = current_user.user_courses.where(:course_id => course.id).first
          u['remove'] = self.class.helpers.link_to "Remove", user_course_path(ucourse), 
            :method => :delete
          u['instructor'] = course.try(:instructor).try(:name)
          u['college'] = course.college.college_tag.upcase
          u['begin_time'] = u['begin_time'].localtime.strftime("%I:%M %p")
          u['end_time'] = u['end_time'].localtime.strftime("%I:%M %p")
          u['friends'] = current_user.find_friends_in_course(u['id']).size
        end
        json_struct = json.struct
        json_struct["iTotalRecords"] = total_record_size
        json_struct["iTotalDisplayRecords"] = total_record_size
        json_struct["sEcho"] = params[:sEcho]
        render :json => json_struct

      }

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
    @user_course = current_user.user_courses.build(:course_id => params[:course_id])

    if @user_course.save
      render :nothing => true
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
