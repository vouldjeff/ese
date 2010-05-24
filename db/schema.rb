# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100316206000) do

  create_table "answers", :force => true do |t|
    t.text    "content"
    t.boolean "correct"
    t.integer "question_id"
  end

  add_index "answers", ["question_id"], :name => "index_answers_on_question_id"

  create_table "assets", :force => true do |t|
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assets", ["attachable_id", "attachable_type"], :name => "index_assets_on_attachable_id_and_attachable_type"

  create_table "assignments", :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "assignments", ["role_id"], :name => "index_assignments_on_role_id"
  add_index "assignments", ["user_id"], :name => "index_assignments_on_user_id"

  create_table "courses", :force => true do |t|
    t.string "name"
    t.text   "description"
    t.string "lang"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.datetime "start_at"
    t.datetime "end_at"
    t.boolean  "all_day"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  add_index "events", ["course_id"], :name => "index_events_on_course_id"

  create_table "links", :force => true do |t|
    t.integer "tag_id"
    t.integer "material_id"
  end

  add_index "links", ["material_id"], :name => "index_links_on_material_id"
  add_index "links", ["tag_id"], :name => "index_links_on_tag_id"

  create_table "materials", :force => true do |t|
    t.string  "name"
    t.text    "content"
    t.integer "course_id"
  end

  add_index "materials", ["course_id"], :name => "index_materials_on_course_id"

  create_table "news", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "news", ["course_id"], :name => "index_news_on_course_id"
  add_index "news", ["user_id"], :name => "index_news_on_user_id"

  create_table "participants", :force => true do |t|
    t.integer "user_id"
    t.integer "course_id"
  end

  add_index "participants", ["course_id"], :name => "index_participants_on_course_id"
  add_index "participants", ["user_id"], :name => "index_participants_on_user_id"

  create_table "questions", :force => true do |t|
    t.integer "kind"
    t.text    "content"
    t.integer "test_id"
    t.integer "weight"
  end

  add_index "questions", ["test_id"], :name => "index_questions_on_test_id"

  create_table "results", :force => true do |t|
    t.integer  "test_id"
    t.integer  "user_id"
    t.float    "result"
    t.text     "answers"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "results", ["test_id"], :name => "index_results_on_test_id"
  add_index "results", ["user_id"], :name => "index_results_on_user_id"

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope",          :limit => 40
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "scope", "sequence"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "tests", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "enabled"
    t.boolean  "can_correct"
    t.integer  "course_id"
    t.datetime "active_from"
    t.datetime "active_to"
    t.integer  "duration"
    t.integer  "weight"
  end

  add_index "tests", ["course_id"], :name => "index_tests_on_course_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "persistence_token"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "facebook_uid",         :limit => 8
    t.string   "facebook_session_key"
  end

end
