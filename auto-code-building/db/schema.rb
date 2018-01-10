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

ActiveRecord::Schema.define(version: 20180109082349) do

  create_table "buildinfos", force: :cascade do |t|
    t.string "project"
    t.string "loginfo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "author"
    t.string "user_name"
    t.string "branch"
    t.string "commit_url"
    t.string "commmit_msg"
    t.string "build_time"
    t.string "build_status"
  end

  create_table "projects", force: :cascade do |t|
    t.string "author"
    t.string "project_name"
    t.string "project_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "buildinfo_num_all"
    t.string "users"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_type"
    t.string "user_name"
    t.string "pwd"
    t.string "last_login"
    t.string "projects_num"
    t.string "buildinfos_num"
    t.string "imgurl"
    t.string "projects"
    t.string "name"
  end

end
