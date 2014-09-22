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

ActiveRecord::Schema.define(version: 20140909171251) do

  create_table "comments", force: true do |t|
    t.string   "type_owner"
    t.text     "body"
    t.integer  "lesson_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["lesson_id"], name: "index_comments_on_lesson_id"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "lessons", force: true do |t|
    t.string   "name"
    t.text     "must_be_practised"
    t.text     "how_to_practise"
    t.integer  "user_id"
    t.date     "date_start"
    t.date     "date_finish"
    t.string   "status"
    t.string   "raiting"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "minutes_hash"
    t.datetime "last_send_mail_datetime"
  end

  add_index "lessons", ["user_id"], name: "index_lessons_on_user_id"

  create_table "lessons_resources", id: false, force: true do |t|
    t.integer "lesson_id"
    t.integer "resource_id"
  end

  add_index "lessons_resources", ["lesson_id"], name: "index_lessons_resources_on_lesson_id"
  add_index "lessons_resources", ["resource_id"], name: "index_lessons_resources_on_resource_id"

  create_table "resources", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment"
    t.string   "tag"
    t.string   "link"
    t.string   "name"
  end

  add_index "resources", ["name"], name: "index_resources_on_name", unique: true

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin",              default: false
    t.boolean  "teacher"
    t.boolean  "parent"
    t.integer  "parent_user_id"
    t.string   "role"
    t.integer  "user_id"
    t.integer  "parent_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["parent_id"], name: "index_users_on_parent_id"

end
