# == Schema Information
#
# Table name: orders
#
#  id           :integer          not null, primary key
#  deleted_at   :datetime
#  desc         :string(255)
#  no           :string(255)
#  order_status :string(255)
#  order_type   :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  project_id   :integer
#  user_id      :integer
#
# Indexes
#
#  index_orders_on_deleted_at  (deleted_at)
#

class Order < ActiveRecord::Base
  include AASM
  belongs_to :project
  has_many :order_products
  has_many :order_invoices
  belongs_to :user
  after_create :set_no
  has_and_belongs_to_many :invoices, join_table: "order_invoices"
  has_one :place_file, -> {where(model_type: 'place')}, class_name: 'Attachment', foreign_key: :model_id
  has_one :deliver_file, -> {where(model_type: 'deliver')}, class_name: 'Attachment', foreign_key: :model_id
  has_one :sign_file, -> {where(model_type: 'sign')}, class_name: 'Attachment', foreign_key: :model_id

  STATUS = {wait: '新订单', apply: '已申请', project_manager_audit: '项目经理已审核',
            regional_manager_audit: '大区经理已审核', normal_admin_audit: '后勤已审核',
            active: '已下单或申请成功', deliver: '已发货', sign: '已签收', failed: '审核失败' }

  ORDER_TYPE = {sample: '样品、礼品', normal: '订单', bargains: '特价订单'}

  aasm :order_status do
    state :wait, :initial => true
    state :apply, :project_manager_audit, :regional_manager_audit, :normal_admin_audit, :active, :deliver, :sign, :failed

    #申请
    event :do_apply do
      transitions :from => [:wait, :failed], :to => :apply, :after => Proc.new {create_project_manager_audit_notice}
    end

    # 下单
    event :do_place do
      transitions :from => [:wait, :failed], :to => :active, :after => Proc.new {create_deliver_notice }
    end

    # 发货
    event :do_deliver do
      transitions :from => :active, :to => :deliver, :after => Proc.new {create_sign_notice }
    end

    # 签收
    event :do_sign do
      transitions :from => :deliver, :to => :sign
    end

    # 项目经理审批
    event :do_project_manager_audit do
      transitions :from => :apply, :to => :project_manager_audit, :after => Proc.new {create_regional_manager_audit_notice }
    end

    # 大区审批
    event :do_regional_manager_audit do
      transitions :from => :project_manager_audit, :to => :regional_manager_audit, :after => Proc.new {create_normal_admin_audit_notice }
    end

    # 后勤审批
    event :do_normal_admin_audit do
      transitions :from => :regional_manager_audit, :to => :normal_admin_audit, :after => Proc.new {create_group_admin_audit_notice }
    end

    # 部门管理审批
    event :do_group_admin_audit do
      transitions :from => :normal_admin_audit, :to => :active, :after => Proc.new {create_active_notice }
    end

    #审批失败
    event :do_failed do
      transitions :from => [:apply, :regional_audit, :normal_admin_audit], :to => :failed, :after => Proc.new {create_failed_notice }
    end

  end

  def real_total_price
    total_price = 0
    order_products.each do |p|
      total_price += p.real_total_price
    end
    total_price
  end

  def set_no
    self.no = 'LG#NO.' + self.id.to_s.rjust(6, '0')
    self.save
  end

  def can_edit?
     self.wait? || self.failed?
  end

  # 通知项目经理审批
  def create_project_manager_audit_notice
    if project.owner.present? && project.owner.organization.present?
      project.owner.organization.users.joins(:role).where('roles.desc = ?', 'project_manager').each do |user|
        Notice.create_notice "#{order_type}_order_need_audit".to_sym, self.id, user.id
      end
    end
  end

  # 通知大区审批
  def create_regional_manager_audit_notice
    if project.owner.present? && project.owner.organization.present? && project.owner.organization.parent.present?
      project.owner.organization.parent.users.joins(:role).where('roles.desc = ?', 'regional_manager').each do |user|
        Notice.create_notice "#{order_type}_order_need_audit".to_sym, self.id, user.id
      end
    end
  end

  # 通知后勤审批
  def create_normal_admin_audit_notice
    User.joins(:role).where('roles.desc = ?', 'normal_admin').each do |user|
      Notice.create_notice "#{order_type}_order_need_audit".to_sym, self.id, user.id
    end
  end

  # 通知管理审批
  def create_group_admin_audit_notice
    User.joins(:role).where('roles.desc = ?', 'group_admin').each do |user|
      Notice.create_notice "#{order_type}_order_need_audit".to_sym, self.id, user.id
    end
  end

  # 通知申请成功 并通知发货
  def create_active_notice
    Notice.create_notice :order_audited, self.id, user_id
    create_deliver_notice
  end

  # 通知发货
  def create_deliver_notice
    User.joins(:role).where('roles.desc = ?', 'normal_admin').each do |user|
      Notice.create_notice :order_deliver, self.id, user.id
    end
  end

  # 通知签收
  def create_sign_notice
    Notice.create_notice :order_sign, self.id, user_id
  end

  # 通知审核失败
  def create_failed_notice
    Notice.create_notice "#{order_type}_order_failed_audit".to_sym, self.id, user_id
  end

  # 获取当前订单状态
  def get_status
    STATUS[self.order_status.to_sym]
  end

  # 获取订单类别
  def get_order_type
    ORDER_TYPE[self.order_type.to_sym]
  end

  def get_place_name
    order_type == 'normal' ? '下单' : '申请'
  end

  class << self
    # 检索
    def search_conn params
      orders = Order.all
      if params[:order_status].present?
        orders = orders.where(order_status: params[:order_status])
      end

      if params[:table_search].present?
        orders = orders.joins(:project, :user).where('projects.name like ? or orders.no like ? or users.name like ?', "%#{params[:table_search]}%", "%#{params[:table_search]}%", "%#{params[:table_search]}%")
      end
      orders
    end
  end





end
