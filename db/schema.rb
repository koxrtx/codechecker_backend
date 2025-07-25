# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_07_04_024850) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ai_answers", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "problem_id", null: false
    t.bigint "category_id"
    t.text "answer_text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "explanation"
    t.text "test_code"
    t.string "method_name"
    t.index ["category_id"], name: "index_ai_answers_on_category_id"
    t.index ["problem_id"], name: "index_ai_answers_on_problem_id"
    t.index ["user_id"], name: "index_ai_answers_on_user_id"
  end

  create_table "answers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "problem_id", null: false
    t.bigint "category_id", null: false
    t.text "answer_text"
    t.boolean "correct"
    t.datetime "answered_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_answers_on_category_id"
    t.index ["problem_id"], name: "index_answers_on_problem_id"
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "problems", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "category_id"
    t.text "question_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date"
    t.index ["category_id"], name: "index_problems_on_category_id"
    t.index ["user_id"], name: "index_problems_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "ai_answers", "categories"
  add_foreign_key "ai_answers", "problems"
  add_foreign_key "ai_answers", "users"
  add_foreign_key "answers", "categories"
  add_foreign_key "answers", "problems"
  add_foreign_key "answers", "users"
  add_foreign_key "problems", "categories"
  add_foreign_key "problems", "users"
end
