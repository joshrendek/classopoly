# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120325013808) do

  create_table "authorizations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "uid",        :limit => 8
    t.string   "provider"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "books", :force => true do |t|
    t.integer  "course_id"
    t.string   "isbn"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "min_price"
    t.float    "max_price"
    t.float    "average_price"
  end

  create_table "colleges", :force => true do |t|
    t.string   "name"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "college_tag"
  end

  create_table "courses", :force => true do |t|
    t.string   "course_number"
    t.string   "section"
    t.string   "title"
    t.string   "reference_number"
    t.integer  "instructor_id"
    t.integer  "seats"
    t.integer  "seats_left"
    t.string   "building"
    t.string   "room"
    t.time     "begin_time"
    t.time     "end_time"
    t.string   "days"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "college_id"
    t.string   "course_college_instructor_hash", :null => false
    t.integer  "year"
    t.string   "term"
  end

  add_index "courses", ["course_college_instructor_hash"], :name => "index_courses_on_course_college_instructor_hash", :unique => true

  create_table "friends", :force => true do |t|
    t.integer  "user_id"
    t.integer  "facebook_friend_id", :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "friends", ["user_id", "facebook_friend_id"], :name => "user_id,facebook_friend_id", :unique => true

  create_table "instructors", :force => true do |t|
    t.string   "name"
    t.integer  "college_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "last_name"
    t.string   "college_name_hash", :null => false
  end

  add_index "instructors", ["college_name_hash"], :name => "index_instructors_on_college_name_hash", :unique => true

  create_table "pending_invites", :force => true do |t|
    t.integer  "uid",        :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "preferences", :force => true do |t|
    t.integer  "user_id"
    t.string   "class_time"
    t.time     "lunch_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "workdays"
  end

  create_table "user_courses", :force => true do |t|
    t.string   "tag"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "facebook_user_id",       :limit => 8
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
