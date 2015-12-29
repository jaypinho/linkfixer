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

ActiveRecord::Schema.define(version: 20151229151300) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "headlines", force: true do |t|
    t.string   "title"
    t.string   "url"
    t.integer  "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "snapshot_id"
  end

  add_index "headlines", ["site_id"], name: "index_headlines_on_site_id", using: :btree
  add_index "headlines", ["snapshot_id"], name: "index_headlines_on_snapshot_id", using: :btree

  create_table "sites", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "selector"
    t.string   "shortcode"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "snapshots", force: true do |t|
    t.string   "filename"
    t.integer  "height"
    t.integer  "width"
    t.integer  "size"
    t.integer  "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "snapshots", ["site_id"], name: "index_snapshots_on_site_id", using: :btree

end
