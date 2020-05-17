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

ActiveRecord::Schema.define(version: 20200516113231) do

  create_table "agents", force: :cascade do |t|
    t.string   "username"
    t.string   "city"
    t.string   "name"
    t.string   "phone"
    t.string   "business"
    t.string   "resources"
    t.string   "scale"
    t.integer  "members"
    t.string   "product"
    t.string   "achievement"
    t.string   "desc"
    t.string   "agent_status"
    t.integer  "user_id"
    t.integer  "apply_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.datetime "deleted_at"
  end

  add_index "agents", ["deleted_at"], name: "index_agents_on_deleted_at"

  create_table "attachments", force: :cascade do |t|
    t.integer  "model_id"
    t.string   "model_type"
    t.string   "path"
    t.string   "file_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  add_index "attachments", ["deleted_at"], name: "index_attachments_on_deleted_at"

  create_table "audit_details", force: :cascade do |t|
    t.integer  "audit_id"
    t.boolean  "status"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "audits", force: :cascade do |t|
    t.integer  "model_id"
    t.string   "model_type"
    t.string   "status"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "from_status"
    t.string   "to_status"
    t.integer  "user_id"
    t.string   "content"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.text     "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "competitors", force: :cascade do |t|
    t.string   "name"
    t.string   "desc"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contracts", force: :cascade do |t|
    t.string   "name"
    t.string   "partner"
    t.string   "product"
    t.datetime "valid_date"
    t.string   "no"
    t.string   "cycle"
    t.text     "others"
    t.integer  "advance_time"
    t.integer  "process_time"
    t.integer  "settlement_time"
    t.integer  "tail_time"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.datetime "deleted_at"
  end

  add_index "contracts", ["deleted_at"], name: "index_contracts_on_deleted_at"

  create_table "cost_categories", force: :cascade do |t|
    t.string   "name"
    t.text     "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "costs", force: :cascade do |t|
    t.integer  "user_id"
    t.float    "amount"
    t.string   "purpose"
    t.datetime "occur_time"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "cost_category_id"
  end

  create_table "deliver_logs", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "user_id"
    t.float    "amount"
    t.datetime "deliver_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delivers", force: :cascade do |t|
    t.integer  "order_id"
    t.string   "phone_to"
    t.string   "phone"
    t.string   "number"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "factories", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.text     "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fund_logs", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "user_id"
    t.datetime "fund_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.string   "no"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "invoice_status"
    t.datetime "apply_at"
    t.datetime "applied_at"
    t.datetime "sended_at"
    t.float    "amount"
  end

  create_table "messages", force: :cascade do |t|
    t.string   "content"
    t.string   "to"
    t.string   "from"
    t.string   "template_id"
    t.string   "status"
    t.string   "send_id"
    t.integer  "fee"
    t.string   "code"
    t.string   "msg"
    t.string   "type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "notices", force: :cascade do |t|
    t.integer  "model_id"
    t.string   "model_type"
    t.string   "content"
    t.boolean  "readed",     default: false
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "order_invoices", force: :cascade do |t|
    t.integer  "invoice_id"
    t.integer  "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_products", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "order_id"
    t.integer  "number"
    t.float    "price"
    t.float    "total_price"
    t.float    "discount",             default: 1.0
    t.float    "discount_price"
    t.float    "discount_total_price"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.datetime "deleted_at"
  end

  add_index "order_products", ["deleted_at"], name: "index_order_products_on_deleted_at"

  create_table "orders", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "order_type"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "user_id"
    t.string   "desc"
    t.string   "order_status"
    t.string   "no"
    t.datetime "deleted_at"
    t.float    "payment",         default: 0.0
    t.datetime "last_payment_at"
    t.integer  "payment_id"
    t.datetime "apply_at"
    t.datetime "applied_at"
    t.float    "payment_percent"
    t.datetime "last_deliver_at"
    t.float    "total_price"
    t.integer  "factory_id"
    t.float    "deliver_amount"
  end

  add_index "orders", ["deleted_at"], name: "index_orders_on_deleted_at"

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "ancestry"
    t.datetime "deleted_at"
  end

  add_index "organizations", ["ancestry"], name: "index_organizations_on_ancestry"
  add_index "organizations", ["deleted_at"], name: "index_organizations_on_deleted_at"

  create_table "payment_logs", force: :cascade do |t|
    t.integer  "order_id"
    t.datetime "payment_at"
    t.float    "amount"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_categories", force: :cascade do |t|
    t.string   "name"
    t.text     "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "no"
    t.string   "name"
    t.string   "product_no"
    t.string   "unit"
    t.float    "reference_price"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.datetime "deleted_at"
    t.string   "brand"
    t.string   "norms"
    t.float    "market_price"
    t.float    "acquisition_price"
    t.float    "freight"
    t.integer  "product_category_id"
    t.string   "color"
    t.text     "desc"
  end

  add_index "products", ["deleted_at"], name: "index_products_on_deleted_at"

  create_table "projects", force: :cascade do |t|
    t.string   "city"
    t.string   "category"
    t.string   "a_name"
    t.string   "name"
    t.string   "address"
    t.string   "supplier_type"
    t.boolean  "strategic"
    t.integer  "estimate"
    t.string   "butt_name"
    t.string   "butt_title"
    t.string   "butt_phone"
    t.integer  "owner_id"
    t.integer  "create_id"
    t.integer  "agency_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "contract_id"
    t.integer  "step",              default: 0
    t.string   "step_status"
    t.string   "purchase"
    t.string   "purchase_phone"
    t.string   "design"
    t.string   "design_phone"
    t.string   "cost"
    t.string   "cost_phone"
    t.string   "settling"
    t.string   "settling_phone"
    t.string   "constructor"
    t.string   "constructor_phone"
    t.string   "supervisor"
    t.string   "supervisor_phone"
    t.float    "payment",           default: 0.0
    t.string   "project_status"
    t.datetime "deleted_at"
    t.datetime "approval_time"
    t.float    "need_payment",      default: 0.0
    t.datetime "shipment_end"
    t.integer  "company_id"
    t.integer  "category_id"
    t.float    "payment_percent"
    t.float    "deliver_amount"
  end

  add_index "projects", ["deleted_at"], name: "index_projects_on_deleted_at"

  create_table "projects_contracts", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "contract_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "reports", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "name"
    t.string   "address"
    t.string   "builder"
    t.string   "project_type"
    t.string   "project_step"
    t.string   "purchase_type"
    t.string   "scale"
    t.string   "product"
    t.string   "supply_time"
    t.string   "source"
    t.string   "desc"
    t.integer  "user_id"
    t.string   "phone"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "resources", force: :cascade do |t|
    t.string   "action"
    t.string   "target"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  add_index "resources", ["deleted_at"], name: "index_resources_on_deleted_at"

  create_table "role_resources", force: :cascade do |t|
    t.integer  "role_id"
    t.integer  "resource_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.string   "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  add_index "roles", ["deleted_at"], name: "index_roles_on_deleted_at"

  create_table "sales", force: :cascade do |t|
    t.integer  "product_id"
    t.float    "price"
    t.integer  "contract_id"
    t.string   "desc"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.float    "discount"
    t.float    "discount_price"
    t.integer  "agent_id"
    t.datetime "deleted_at"
  end

  add_index "sales", ["deleted_at"], name: "index_sales_on_deleted_at"

  create_table "sign_logs", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "user_id"
    t.datetime "sign_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trains", force: :cascade do |t|
    t.string   "name"
    t.string   "desc"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "action_type"
  end

  create_table "user_roles", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "login"
    t.string   "name"
    t.integer  "role_id"
    t.integer  "organization_id"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "agent_id"
    t.datetime "deleted_at"
    t.string   "title"
  end

  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at"
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
