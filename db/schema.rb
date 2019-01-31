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

ActiveRecord::Schema.define(version: 20190131071608) do

  create_table "attachments", force: :cascade do |t|
    t.integer  "model_id",   limit: 4
    t.string   "model_type", limit: 255
    t.string   "path",       limit: 255
    t.string   "file_name",  limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "audit_details", force: :cascade do |t|
    t.integer  "audit_id",   limit: 4
    t.boolean  "status"
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "audits", force: :cascade do |t|
    t.integer  "model_id",    limit: 4
    t.string   "model_type",  limit: 255
    t.string   "status",      limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "from_status", limit: 255
    t.string   "to_status",   limit: 255
    t.integer  "user_id",     limit: 4
    t.string   "content",     limit: 255
  end

  create_table "contracts", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "partner",         limit: 255
    t.string   "product",         limit: 255
    t.datetime "valid_date"
    t.string   "no",              limit: 255
    t.string   "cycle",           limit: 255
    t.text     "others",          limit: 65535
    t.integer  "advance_time",    limit: 4
    t.integer  "process_time",    limit: 4
    t.integer  "settlement_time", limit: 4
    t.integer  "tail_time",       limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.integer  "project_id", limit: 4
    t.integer  "user_id",    limit: 4
    t.string   "no",         limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "notices", force: :cascade do |t|
    t.integer  "model_id",   limit: 4
    t.string   "model_type", limit: 255
    t.string   "content",    limit: 255
    t.boolean  "readed",                 default: false
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "order_invoices", force: :cascade do |t|
    t.integer  "invoice_id", limit: 4
    t.integer  "order_id",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "order_products", force: :cascade do |t|
    t.integer  "product_id",           limit: 4
    t.integer  "order_id",             limit: 4
    t.integer  "number",               limit: 4
    t.float    "price",                limit: 24
    t.float    "total_price",          limit: 24
    t.float    "discount",             limit: 24
    t.float    "discount_price",       limit: 24
    t.float    "discount_total_price", limit: 24
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "project_id",   limit: 4
    t.string   "order_type",   limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "user_id",      limit: 4
    t.string   "desc",         limit: 255
    t.string   "order_status", limit: 255
    t.string   "no",           limit: 255
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "ancestry",   limit: 255
  end

  add_index "organizations", ["ancestry"], name: "index_organizations_on_ancestry", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "no",              limit: 255
    t.string   "product_no",      limit: 255
    t.string   "unit",            limit: 255
    t.float    "reference_price", limit: 24
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "name",            limit: 255
  end

  create_table "projects", force: :cascade do |t|
    t.string   "city",              limit: 255
    t.string   "category",          limit: 255
    t.string   "a_name",            limit: 255
    t.string   "name",              limit: 255
    t.string   "address",           limit: 255
    t.string   "supplier_type",     limit: 255
    t.boolean  "strategic"
    t.integer  "estimate",          limit: 4
    t.string   "butt_name",         limit: 255
    t.string   "butt_title",        limit: 255
    t.string   "butt_phone",        limit: 255
    t.integer  "owner_id",          limit: 4
    t.integer  "create_id",         limit: 4
    t.integer  "agency_id",         limit: 4
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "contract_id",       limit: 4
    t.integer  "step",              limit: 4,   default: 0
    t.string   "step_status",       limit: 255
    t.string   "purchase",          limit: 255
    t.string   "purchase_phone",    limit: 255
    t.string   "design",            limit: 255
    t.string   "design_phone",      limit: 255
    t.string   "cost",              limit: 255
    t.string   "cost_phone",        limit: 255
    t.string   "settling",          limit: 255
    t.string   "settling_phone",    limit: 255
    t.string   "constructor",       limit: 255
    t.string   "constructor_phone", limit: 255
    t.string   "supervisor",        limit: 255
    t.string   "supervisor_phone",  limit: 255
    t.string   "payment",           limit: 255
    t.string   "project_status",    limit: 255
  end

  create_table "resources", force: :cascade do |t|
    t.string   "action",     limit: 255
    t.string   "target",     limit: 255
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "role_resources", force: :cascade do |t|
    t.integer  "role_id",     limit: 4
    t.integer  "resource_id", limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "desc",       limit: 255
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "sales", force: :cascade do |t|
    t.integer  "product_id",     limit: 4
    t.float    "price",          limit: 24
    t.integer  "contract_id",    limit: 4
    t.string   "desc",           limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.float    "discount",       limit: 24
    t.float    "discount_price", limit: 24
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "login",                  limit: 255
    t.string   "name",                   limit: 255
    t.integer  "role_id",                limit: 4
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "organization_id",        limit: 4
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
