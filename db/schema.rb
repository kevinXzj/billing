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

ActiveRecord::Schema.define(version: 20160413024942) do

  create_table "bill_items", force: :cascade do |t|
    t.decimal  "voice",                precision: 10, scale: 2
    t.decimal  "message",              precision: 10, scale: 2
    t.decimal  "internet",             precision: 10, scale: 2
    t.decimal  "service",              precision: 10, scale: 2
    t.decimal  "proxy",                precision: 10, scale: 2
    t.integer  "bill_id",    limit: 4
    t.integer  "number_id",  limit: 4,                          null: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  add_index "bill_items", ["bill_id"], name: "fk_rails_6de1f5051f", using: :btree
  add_index "bill_items", ["number_id"], name: "fk_rails_e8f2222a4d", using: :btree

  create_table "bills", force: :cascade do |t|
    t.integer  "bill_import_log_id", limit: 4
    t.integer  "year",               limit: 4
    t.integer  "month",              limit: 4
    t.text     "remark",             limit: 65535
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "bills", ["bill_import_log_id"], name: "fk_rails_370c407e0f", using: :btree

  create_table "companies", force: :cascade do |t|
    t.string   "name",                       limit: 255
    t.string   "bill_num",                   limit: 255
    t.string   "tel_office",                 limit: 255
    t.date     "apply_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "company_import_log_id",      limit: 4
    t.integer  "issue_number_import_log_id", limit: 4
  end

  add_index "companies", ["company_import_log_id"], name: "fk_rails_2728a52e9c", using: :btree
  add_index "companies", ["issue_number_import_log_id"], name: "fk_rails_de8d547569", using: :btree

  create_table "customers", force: :cascade do |t|
    t.string   "name",                       limit: 255,   null: false
    t.string   "linkman",                    limit: 255
    t.string   "phone",                      limit: 255
    t.string   "address",                    limit: 255
    t.text     "remark",                     limit: 65535
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "issue_number_import_log_id", limit: 4
  end

  add_index "customers", ["issue_number_import_log_id"], name: "fk_rails_a680ea01ea", using: :btree

  create_table "import_logs", force: :cascade do |t|
    t.string   "file_name",  limit: 255
    t.string   "file_path",  limit: 255
    t.string   "type",       limit: 255
    t.text     "remark",     limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "issue_numbers", force: :cascade do |t|
    t.integer  "customer_id",                limit: 4, null: false
    t.integer  "number_id",                  limit: 4, null: false
    t.integer  "issue_number_import_log_id", limit: 4
    t.date     "issue_at"
    t.date     "back_at"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "issue_numbers", ["customer_id"], name: "fk_rails_5032e09057", using: :btree
  add_index "issue_numbers", ["issue_number_import_log_id"], name: "fk_rails_2b6fb1a934", using: :btree
  add_index "issue_numbers", ["number_id"], name: "fk_rails_e07c0a9c5f", using: :btree

  create_table "numbers", force: :cascade do |t|
    t.string   "phone_num",                  limit: 255
    t.string   "real_num",                   limit: 255
    t.date     "apply_at"
    t.integer  "company_id",                 limit: 4
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "number_import_log_id",       limit: 4
    t.integer  "issue_number_import_log_id", limit: 4
  end

  add_index "numbers", ["company_id"], name: "fk_rails_2102df6c07", using: :btree
  add_index "numbers", ["issue_number_import_log_id"], name: "fk_rails_83eafb31ee", using: :btree
  add_index "numbers", ["number_import_log_id"], name: "fk_rails_0c12007242", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "login",           limit: 255
    t.string   "hashed_password", limit: 255
    t.string   "salt",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "bill_items", "bills", on_delete: :cascade
  add_foreign_key "bill_items", "numbers"
  add_foreign_key "bills", "import_logs", column: "bill_import_log_id", on_delete: :cascade
  add_foreign_key "companies", "import_logs", column: "company_import_log_id", on_delete: :cascade
  add_foreign_key "companies", "import_logs", column: "issue_number_import_log_id", on_delete: :cascade
  add_foreign_key "customers", "import_logs", column: "issue_number_import_log_id", on_delete: :cascade
  add_foreign_key "issue_numbers", "customers"
  add_foreign_key "issue_numbers", "import_logs", column: "issue_number_import_log_id", on_delete: :cascade
  add_foreign_key "issue_numbers", "numbers"
  add_foreign_key "numbers", "companies", on_delete: :cascade
  add_foreign_key "numbers", "import_logs", column: "issue_number_import_log_id", on_delete: :cascade
  add_foreign_key "numbers", "import_logs", column: "number_import_log_id", on_delete: :cascade
end
