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

ActiveRecord::Schema.define(version: 20170731193721) do

  create_table "games", force: :cascade do |t|
    t.integer "decks"
    t.text "players"
    t.text "cards"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
  end

  create_table "hands", force: :cascade do |t|
    t.text "cards"
    t.integer "coins"
    t.integer "payoff"
    t.string "status"
    t.integer "insurance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_game_id"
    t.index ["user_game_id"], name: "index_hands_on_user_game_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.text "dealer_cards"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "game_id"
    t.index ["game_id"], name: "index_rounds_on_game_id"
  end

  create_table "user_games", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "game_id"
    t.index ["game_id"], name: "index_user_games_on_game_id"
    t.index ["user_id"], name: "index_user_games_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.integer "coins"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
