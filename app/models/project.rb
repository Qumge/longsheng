# == Schema Information
#
# Table name: projects
#
#  id                :integer          not null, primary key
#  a_name            :string(255)
#  address           :string(255)
#  butt_name         :string(255)
#  butt_phone        :string(255)
#  butt_title        :string(255)
#  category          :string(255)
#  city              :string(255)
#  constructor       :string(255)
#  constructor_phone :string(255)
#  cost              :string(255)
#  cost_phone        :string(255)
#  design            :string(255)
#  design_phone      :string(255)
#  estimate          :integer
#  name              :string(255)
#  purchase          :string(255)
#  purchase_phone    :string(255)
#  settling          :string(255)
#  settling_phone    :string(255)
#  step              :integer          default(0)
#  step_status       :string(255)
#  strategic         :boolean
#  supervisor        :string(255)
#  supervisor_phone  :string(255)
#  supplier_type     :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  agency_id         :integer
#  contract_id       :integer
#  create_id         :integer
#  owner_id          :integer
#

class Project < ActiveRecord::Base
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  belongs_to :create_user, class_name: 'User', foreign_key: :create_id
  has_one :audit, -> {where(model_type: 'Project')}, foreign_key: :model_id
  after_create :create_audit
  validates_presence_of :name, :a_name, :category, :address, :city, :supplier_type
  validates_numericality_of :estimate, if: Proc.new{|p| p.estimate.present?}
  has_one :project_contract, -> {where(model_type: 'contract')}, class_name: 'Attachment', foreign_key: :model_id
  has_one :advance, -> {where(model_type: 'advance')}, class_name: 'Attachment', foreign_key: :model_id
  has_one :plate, -> {where(model_type: 'plate')}, class_name: 'Attachment', foreign_key: :model_id
  has_many :payments, -> {where(model_type: 'payment')}, class_name: 'Attachment', foreign_key: :model_id
  has_many :settlements, -> {where(model_type: 'settlement')}, class_name: 'Attachment', foreign_key: :model_id
  has_many :attachments, foreign_key: :model_id
  has_one :bond, -> {where(model_type: 'bond')}, class_name: 'Attachment', foreign_key: :model_id
  has_many :orders
  has_many :sample_orders, -> {where(order_type: 'sample')}, class_name: 'Order', foreign_key: :order_id
  has_many :normal_orders, -> {where(order_type: 'normal')}, class_name: 'Order', foreign_key: :order_id
  belongs_to :contract
  has_many :invoices

  # 根据审核表获取当前的审核状态
  def status
    ''
  end

  def order_invoices
    OrderInvoice.includes(:order).where('orders.project_id = ?', self.id).references(:order)
  end


  def can_invoice_orders
    self.orders.where('orders.id not in (?)', self.order_invoices.collect{|o| o.order_id})
  end
  

  private
  def create_audit
    Audit.create model_id: self.id, model_type: self.class.name
  end
end
