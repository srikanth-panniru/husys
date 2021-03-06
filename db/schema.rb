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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140224064353) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", force: true do |t|
    t.string   "course_id"
    t.string   "course_name"
    t.string   "category"
    t.string   "sub_category"
    t.string   "exam_name"
    t.float    "duration"
    t.integer  "no_of_questions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pass_criteria_1"
    t.string   "pass_text_1"
    t.string   "pass_criteria_2"
    t.string   "pass_text_2"
    t.string   "pass_criteria_3"
    t.string   "pass_text_3"
    t.string   "pass_criteria_4"
    t.string   "pass_text_4"
  end

  create_table "descriptive_questions", force: true do |t|
    t.integer  "course_id"
    t.string   "description"
    t.string   "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exam_centers", force: true do |t|
    t.string   "center_name"
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "pin"
    t.string   "center_email"
    t.string   "phone"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "assigned_user_id"
  end

  create_table "machines", force: true do |t|
    t.string   "machine_id"
    t.integer  "exam_center_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", force: true do |t|
    t.integer  "course_id"
    t.string   "description"
    t.string   "option_1"
    t.string   "option_2"
    t.string   "option_3"
    t.string   "option_4"
    t.string   "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "registrations", force: true do |t|
    t.integer  "student_id"
    t.integer  "exam_center_id"
    t.integer  "machine_id"
    t.integer  "course_id"
    t.date     "exam_date"
    t.time     "exam_start_time"
    t.time     "exam_end_time"
    t.date     "registration_date"
    t.integer  "no_of_attempts"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "access_password"
    t.string   "registration_id"
    t.string   "status"
  end

  create_table "results", force: true do |t|
    t.integer  "registration_id"
    t.integer  "total_marks"
    t.float    "marks_secured"
    t.string   "exam_result"
    t.string   "pass_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "role"
    t.string   "code"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_id"
    t.integer  "role_id"
    t.string   "name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["user_id"], name: "index_users_on_user_id", unique: true, using: :btree

end
