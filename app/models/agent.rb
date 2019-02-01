# == Schema Information
#
# Table name: agents
#
#  id           :integer          not null, primary key
#  achievement  :string(255)
#  agent_status :string(255)
#  business     :string(255)
#  city         :string(255)
#  company      :string(255)
#  desc         :string(255)
#  members      :integer
#  name         :string(255)
#  phone        :string(255)
#  product      :string(255)
#  resources    :string(255)
#  scale        :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  apply_id     :integer
#  user_id      :integer
#

class Agent < ActiveRecord::Base
  belongs_to :user
  belongs_to :apply_user, class_name: 'User', foreign_key: :apply_id
  include AASM

  after_create :create_project_manager_audit_notice

  aasm :order_status do
    state :apply, :initial => true
    state :project_manager_audit, :regional_manager_audit, :normal_admin_audit, :active

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


  # 通知项目经理审批
  def create_project_manager_audit_notice
    if apply_user.present? && apply_user.organization.present?
      apply_user.organization.users.joins(:role).where('roles.desc = ?', 'project_manager').each do |user|
        Notice.create_notice :agent_need_audit, self.id, user.id
      end
    end
  end

  # 通知大区审批
  def create_regional_manager_audit_notice
    if apply_user.present? && apply_user.organization.present? && apply_user.organization.parent.present?
      apply_user.organization.parent.users.joins(:role).where('roles.desc = ?', 'regional_manager').each do |user|
        Notice.create_notice :agent_need_audit, self.id, user.id
      end
    end
  end

  # 通知后勤审批
  def create_normal_admin_audit_notice
    User.joins(:role).where('roles.desc = ?', 'normal_admin').each do |user|
      Notice.create_notice :agent_need_audit, self.id, user.id
    end
  end

  # 通知管理审批
  def create_group_admin_audit_notice
    User.joins(:role).where('roles.desc = ?', 'group_admin').each do |user|
      Notice.create_notice :agent_need_audit, self.id, user.id
    end
  end

  # 通知申请成功 并通知发货
  def create_active_notice
    Notice.create_notice :agent_audited, self.id, apply_id
  end

  # 通知审核失败
  def create_failed_notice
    Notice.create_notice :agent_failed_audit, self.id, apply_id
  end


end