class CoursesController < ApplicationController
  before_filter :require_login!

  layout :choose_layout

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
            e = e.page(page).per(display_length)
            #logger.info "EQ: " + e.to_sql
          else
            total_record_size = e.count
            e = e.page(page).per(display_length)
          end


          json = DatatablesRails::Structify.new(e)
          
          json.formatter do |u|
            course = Course.find(u['id'])
            if current_user.courses.where(:id => u['id']).first.blank?
              u['add'] = self.class.helpers.link_to "Add", user_courses_path(:course_id => u['id']), :method => :post, :remote => :true, :onclick => "$(this).html('Added')"
            else
              u['add'] = "Added"
            end
            u['course_number'] = self.class.helpers.link_to u['course_number'], course_path(:id => u['id'])
            u['instructor'] = self.class.helpers.link_to course.try(:instructor).try(:name), instructor_path(:id => course.try(:instructor_id))
            u['college'] = course.college.college_tag.upcase
            u['begin_time'] = u['begin_time'].strftime("%I:%M %p")
            u['end_time'] = u['end_time'].strftime("%I:%M %p")
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
    @wall_message = WallMessage.new
    @type = @course

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @course }
    end
  end

  private
  def choose_layout 
    if ['show'].include? action_name
      'sidebar_layout'
    else
      'application'
    end
  end


end
