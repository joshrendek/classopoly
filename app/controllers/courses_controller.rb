class CoursesController < ApplicationController
  before_filter :require_login!

  DatatableFields = ["add", "course_number", "section", "title","instructor", 
                     "seats_left", "seats", "building", "room", "begin_time",
                     "end_time", "days", "friends"]


  # GET /courses
  # GET /courses.json
  def index

    respond_to do |format|
      format.html # index.html.haml
      format.json {
          page = 1

          page = params[:iDisplayStart].to_i/10+1 if params[:iDisplayStart]
          e = Course
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
            
            search = DatatableFields.collect{|d| "#{d} LIKE '%#{params[:sSearch]}%'" unless ["college","instructor", "add", "friends"].include?(d) }.compact.join(' OR ')
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
            if current_user.courses.where(:id => u['id']).first.blank?
              u['add'] = self.class.helpers.link_to "Add", user_courses_path(:course_id => u['id']), :method => :post, :remote => :true, :onclick => "$(this).html('Added')"
            else
              u['add'] = "Added"
            end
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

  # GET /courses/1
  # GET /courses/1.json
  def show
    @course = Course.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @course }
    end
  end

  # GET /courses/new
  # GET /courses/new.json
  def new
    @course = Course.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @course }
    end
  end

  # GET /courses/1/edit
  def edit
    @course = Course.find(params[:id])
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(params[:course])

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render json: @course, status: :created, location: @course }
      else
        format.html { render action: "new" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /courses/1
  # PUT /courses/1.json
  def update
    @course = Course.find(params[:id])

    respond_to do |format|
      if @course.update_attributes(params[:course])
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course = Course.find(params[:id])
    @course.destroy

    respond_to do |format|
      format.html { redirect_to courses_url }
      format.json { head :ok }
    end
  end
end
