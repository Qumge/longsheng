# == Schema Information
#
# Table name: orders
#
#  id           :integer          not null, primary key
#  desc         :string(255)
#  order_status :string(255)
#  order_type   :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  project_id   :integer
#  user_id      :integer
#

class Order < ActiveRecord::Base
  include AASM
  belongs_to :project
  has_many :order_products
  has_many :order_invoices
  belongs_to :user
  has_and_belongs_to_many :invoices, join_table: "order_invoices"
  has_one :place, -> {where(model_type: 'place')}, class_name: 'Attachment', foreign_key: :model_id
  has_one :deliver, -> {where(model_type: 'deliver')}, class_name: 'Attachment', foreign_key: :model_id
  has_one :sign, -> {where(model_type: 'sign')}, class_name: 'Attachment', foreign_key: :model_id

  aasm :order_status do
    state :wait, :initial => true
    state :apply, :project_manager_audit, :regional_manager_audit, :normal_admin_audit, :active, :deliver, :sign, :overdue, :failed

    #申请
    event :do_apply do
      transitions :from => :wait, :to => :apply, :after => Proc.new {create_project_manager_audit_notice}
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

  def no
    'LG#NO.' + id.to_s.rjust(6, '0')
  end

  def can_edit?
    self.project.can_do? :order &&  (self.wait? || self.failed?)
  end

  # 同住项目经理审批
  def create_project_manager_audit_notice
    if project.owner.present? && project.owner.organization.present?
      project.owner.organization.users.joins(:role).where('roles.desc = ?', 'project_manager').each do |user|
        Notice.create_notice :order_need_audit, self.id, user.id
      end
    end
  end

  # 通知大区审批
  def create_regional_manager_audit_notice
    if project.owner.present? && project.owner.organization.present? && project.owner.organization.parent.present?
      project.owner.organization.parent.users.joins(:role).where('roles.desc = ?', 'regional_manager').each do |user|
        Notice.create_notice :order_need_audit, self.id, user.id
      end
    end
  end

  # 通知后勤审批
  def create_normal_admin_audit_notice
    User.joins(:role).where('roles.desc = ?', 'normal_admin').each do |user|
      Notice.create_notice :order_need_audit, self.id, user.id
    end
  end

  # 通知管理审批
  def create_group_admin_audit_notice
    User.joins(:role).where('roles.desc = ?', 'group_admin').each do |user|
      Notice.create_notice :order_need_audit, self.id, user.id
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
    Notice.create_notice :order_failed_audit, self.id, user_id
  end



end
