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

ActiveRecord::Schema.define(:version => 20110421072649) do

  create_table "place_settings", :force => true do |t|
    t.integer  "place_id",   :null => false
    t.text     "backend"
    t.text     "key",        :null => false
    t.text     "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "place_settings", ["place_id", "key", "backend"], :name => "index_place_settings_on_place_id_and_key_and_backend", :unique => true

  create_table "places", :force => true do |t|
    t.integer  "user_id",                   :null => false
    t.text     "name",                      :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "ordinal",    :default => 0, :null => false
  end

  add_index "places", ["user_id", "ordinal"], :name => "index_places_on_user_id_and_ordinal", :unique => true

  create_table "settings", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.text     "key",        :null => false
    t.text     "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.text     "username",      :null => false
    t.text     "password_hash"
    t.text     "email"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

end
