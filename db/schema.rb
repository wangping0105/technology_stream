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

ActiveRecord::Schema.define(version: 20140513050549) do

  create_table "attentions", force: true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities", force: true do |t|
    t.integer  "code"
    t.string   "name"
    t.integer  "provincecode"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "collections", force: true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.integer  "user_id"
    t.integer  "target_user_id"
    t.string   "content"
    t.integer  "post_id"
    t.boolean  "status"
    t.integer  "types"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "nodes", force: true do |t|
    t.string   "name"
    t.integer  "section_id"
    t.integer  "sort"
    t.integer  "posts_count"
    t.string   "summary"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "nodes", ["section_id"], name: "index_nodes_on_section_id", using: :btree

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "node_id"
    t.integer  "user_id"
    t.boolean  "status"
    t.boolean  "cream"
    t.integer  "browser_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "replies_count"
    t.integer  "collections_count"
    t.integer  "praises_count"
    t.integer  "attentions_count"
  end

  add_index "posts", ["title"], name: "index_posts_on_title", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "praises", force: true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "provinces", force: true do |t|
    t.integer  "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "replies", force: true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "replies", ["post_id"], name: "index_replies_on_post_id", using: :btree
  add_index "replies", ["user_id"], name: "index_replies_on_user_id", using: :btree

  create_table "reply_agains", force: true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.integer  "target_user_id"
    t.integer  "reply_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reply_agains", ["reply_id"], name: "index_reply_agains_on_reply_id", using: :btree

  create_table "sections", force: true do |t|
    t.string   "name"
    t.integer  "sort"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: true do |t|
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["content"], name: "index_tags_on_content", using: :btree

  create_table "tags_post_relations", force: true do |t|
    t.integer  "tag_id"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags_post_relations", ["post_id"], name: "index_tags_post_relations_on_post_id", using: :btree
  add_index "tags_post_relations", ["tag_id"], name: "index_tags_post_relations_on_tag_id", using: :btree

  create_table "tips", force: true do |t|
    t.string   "content"
    t.integer  "types"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_read_records", force: true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.float    "times"
    t.integer  "count",      default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_read_records", ["post_id"], name: "index_user_read_records_on_post_id", using: :btree
  add_index "user_read_records", ["user_id"], name: "index_user_read_records_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "name"
    t.string   "location"
    t.integer  "qq"
    t.string   "website"
    t.integer  "role"
    t.boolean  "status"
    t.string   "github"
    t.integer  "sex"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.string   "avatar_url"
    t.string   "remark"
  end

end
