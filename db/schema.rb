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

ActiveRecord::Schema.define(:version => 20100221230129) do

  create_table "place_settings", :force => true do |t|
    t.integer  "place_id",   :null => false
    t.text     "backend"
    t.text     "key",        :null => false
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "place_settings", ["key", "backend"], :name => "index_place_settings_on_key_and_backend", :unique => true

  create_table "places", :force => true do |t|
    t.integer  "user_id",          :null => false
    t.text     "name",             :null => false
    t.text     "serialized_style"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.text     "key",        :null => false
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.text     "username",      :null => false
    t.text     "password_hash"
    t.text     "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
