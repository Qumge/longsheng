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
    state :regional_audit, :normal_admin_audit, :group_admin_audit, :active, :finish, :overdue, :failed

    event :do_regional_audit do
      transitions :from => :wait, :to => :regional_audit, :after => Proc.new {create_admin_audit_notice }
    end

    event :do_normal_admin_audit do
      transitions :from => :regional_audit, :to => :normal_admin_audit, :after => Proc.new {create_normal_admin_audit_notice }
    end

    event :do_group_admin_audit do
      transitions :from => :normal_admin_audit, :to => :group_admin_audit, :after => Proc.new {create_group_admin_audit_notice }
    end

    event :do_active do
      transitions :from => :group_admin_audit, :to => :active, :after => Proc.new {create_active_notice }
    end

    event :do_failed do
      transitions :from => [:wait, :regional_audit, normal_admin_audit, :group_admin_audit], :to => :failed
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

  # TODO
  def can_edit?
    self.project.can_do? :order
  end

  def create_audit_notice
    if project.owner.present? && project.owner.organization.present? && project.owner.organization.parent.present?
      project.owner.organization.parent.users.joins(:role).where('roles.desc = ?', 'regional_manager').each do |user|
        Notice.create_notice :order_need_audit, self.id, user.id
      end
    end
  end

  def create_normal_admin_audit_notice
    User.joins(:role).where('roles.desc = ?', 'normal_admin').each do |user|
      Notice.create_notice :order_need_audit, self.id, user.id
    end
  end

  def create_group_admin_audit_notice
    User.joins(:role).where('roles.desc = ?', 'group_admin').each do |user|
      Notice.create_notice :order_need_audit, self.id, user.id
    end
  end

  def create_active_notice
    Notice.create_notice :order_audited, self.id, owner_id
  end


end
