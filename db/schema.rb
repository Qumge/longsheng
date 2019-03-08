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

ActiveRecord::Schema.define(version: 20190308022719) do

  create_table "agents", force: :cascade do |t|
    t.string   "username",     limit: 255
    t.string   "city",         limit: 255
    t.string   "name",         limit: 255
    t.string   "phone",        limit: 255
    t.string   "business",     limit: 255
    t.string   "resources",    limit: 255
    t.string   "scale",        limit: 255
    t.integer  "members",      limit: 4
    t.string   "product",      limit: 255
    t.string   "achievement",  limit: 255
    t.string   "desc",         limit: 255
    t.string   "agent_status", limit: 255
    t.integer  "user_id",      limit: 4
    t.integer  "apply_id",     limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.datetime "deleted_at"
  end

  add_index "agents", ["deleted_at"], name: "index_agents_on_deleted_at", using: :btree

  create_table "attachments", force: :cascade do |t|
    t.integer  "model_id",   limit: 4
    t.string   "model_type", limit: 255
    t.string   "path",       limit: 255
    t.string   "file_name",  limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.datetime "deleted_at"
  end

  add_index "attachments", ["deleted_at"], name: "index_attachments_on_deleted_at", using: :btree

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

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "desc",       limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "competitors", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "desc",       limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
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
    t.datetime "deleted_at"
  end

  add_index "contracts", ["deleted_at"], name: "index_contracts_on_deleted_at", using: :btree

  create_table "cost_categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "desc",       limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "costs", force: :cascade do |t|
    t.integer  "user_id",          limit: 4
    t.float    "amount",           limit: 24
    t.string   "purpose",          limit: 255
    t.datetime "occur_time"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "cost_category_id", limit: 4
  end

  create_table "delivers", force: :cascade do |t|
    t.integer  "order_id",   limit: 4
    t.string   "phone_to",   limit: 255
    t.string   "phone",      limit: 255
    t.string   "number",     limit: 255
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "factories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "address",    limit: 255
    t.text     "desc",       limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.integer  "project_id",     limit: 4
    t.integer  "user_id",        limit: 4
    t.string   "no",             limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "invoice_status", limit: 255
    t.datetime "apply_at"
    t.datetime "applied_at"
    t.datetime "sended_at"
    t.float    "amount",         limit: 24
  end

  create_table "messages", force: :cascade do |t|
    t.string   "content",     limit: 255
    t.string   "to",          limit: 255
    t.string   "from",        limit: 255
    t.string   "template_id", limit: 255
    t.string   "status",      limit: 255
    t.string   "send_id",     limit: 255
    t.integer  "fee",         limit: 4
    t.string   "code",        limit: 255
    t.string   "msg",         limit: 255
    t.string   "type",        limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
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
    t.float    "discount",             limit: 24, default: 1.0
    t.float    "discount_price",       limit: 24
    t.float    "discount_total_price", limit: 24
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.datetime "deleted_at"
  end

  add_index "order_products", ["deleted_at"], name: "index_order_products_on_deleted_at", using: :btree

  create_table "orders", force: :cascade do |t|
    t.integer  "project_id",      limit: 4
    t.string   "order_type",      limit: 255
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "user_id",         limit: 4
    t.string   "desc",            limit: 255
    t.string   "order_status",    limit: 255
    t.string   "no",              limit: 255
    t.datetime "deleted_at"
    t.float    "payment",         limit: 24,  default: 0.0
    t.datetime "payment_at"
    t.integer  "payment_id",      limit: 4
    t.datetime "apply_at"
    t.datetime "applied_at"
    t.float    "payment_percent", limit: 24
    t.datetime "deliver_at"
    t.float    "total_price",     limit: 24
    t.integer  "factory_id",      limit: 4
  end

  add_index "orders", ["deleted_at"], name: "index_orders_on_deleted_at", using: :btree

  create_table "organizations", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "ancestry",   limit: 255
    t.datetime "deleted_at"
  end

  add_index "organizations", ["ancestry"], name: "index_organizations_on_ancestry", using: :btree
  add_index "organizations", ["deleted_at"], name: "index_organizations_on_deleted_at", using: :btree

  create_table "payment_logs", force: :cascade do |t|
    t.integer  "order_id",   limit: 4
    t.datetime "payment_at"
    t.float    "amount",     limit: 24
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "product_categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "desc",       limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "no",                  limit: 255
    t.string   "name",                limit: 255
    t.string   "product_no",          limit: 255
    t.string   "unit",                limit: 255
    t.float    "reference_price",     limit: 24
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.datetime "deleted_at"
    t.string   "brand",               limit: 255
    t.string   "norms",               limit: 255
    t.float    "market_price",        limit: 24
    t.float    "acquisition_price",   limit: 24
    t.float    "freight",             limit: 24
    t.integer  "product_category_id", limit: 4
    t.string   "color",               limit: 255
    t.text     "desc",                limit: 65535
  end

  add_index "products", ["deleted_at"], name: "index_products_on_deleted_at", using: :btree

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
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
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
    t.float    "payment",           limit: 24,  default: 0.0
    t.string   "project_status",    limit: 255
    t.datetime "deleted_at"
    t.datetime "approval_time"
    t.float    "need_payment",      limit: 24,  default: 0.0
    t.datetime "shipment_end"
    t.integer  "company_id",        limit: 4
    t.integer  "category_id",       limit: 4
    t.float    "payment_percent",   limit: 24
  end

  add_index "projects", ["deleted_at"], name: "index_projects_on_deleted_at", using: :btree

  create_table "reports", force: :cascade do |t|
    t.integer  "project_id",    limit: 4
    t.string   "name",          limit: 255
    t.string   "address",       limit: 255
    t.string   "builder",       limit: 255
    t.string   "project_type",  limit: 255
    t.string   "project_step",  limit: 255
    t.string   "purchase_type", limit: 255
    t.string   "scale",         limit: 255
    t.string   "product",       limit: 255
    t.string   "supply_time",   limit: 255
    t.string   "source",        limit: 255
    t.string   "desc",          limit: 255
    t.integer  "user_id",       limit: 4
    t.string   "phone",         limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "resources", force: :cascade do |t|
    t.string   "action",     limit: 255
    t.string   "target",     limit: 255
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.datetime "deleted_at"
  end

  add_index "resources", ["deleted_at"], name: "index_resources_on_deleted_at", using: :btree

  create_table "role_resources", force: :cascade do |t|
    t.integer  "role_id",     limit: 4
    t.integer  "resource_id", limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "desc",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.datetime "deleted_at"
  end

  add_index "roles", ["deleted_at"], name: "index_roles_on_deleted_at", using: :btree

  create_table "sales", force: :cascade do |t|
    t.integer  "product_id",     limit: 4
    t.float    "price",          limit: 24
    t.integer  "contract_id",    limit: 4
    t.string   "desc",           limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.float    "discount",       limit: 24
    t.float    "discount_price", limit: 24
    t.integer  "agent_id",       limit: 4
    t.datetime "deleted_at"
  end

  add_index "sales", ["deleted_at"], name: "index_sales_on_deleted_at", using: :btree

  create_table "trains", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "desc",       limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "user_roles", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "role_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "login",                  limit: 255
    t.string   "name",                   limit: 255
    t.integer  "role_id",                limit: 4
    t.integer  "organization_id",        limit: 4
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
    t.integer  "agent_id",               limit: 4
    t.datetime "deleted_at"
    t.string   "title",                  limit: 255
  end

  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
