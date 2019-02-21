# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  deleted_at             :datetime
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  login                  :string(255)
#  name                   :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  sign_in_count          :integer          default(0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  agent_id               :integer
#  organization_id        :integer
#  role_id                :integer
#
# Indexes
#
#  index_users_on_deleted_at            (deleted_at)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :role
  belongs_to :organization
  has_many :notices
  has_many :active_notices, -> {where(readed: false)}, class_name: 'Notice', foreign_key: :user_id
  has_many :resources, through: :role
  has_many :audits
  belongs_to :agent
  validates_presence_of :role_id

  validate do |user|
    user.must_has_one_agent
  end

  def must_has_one_agent
    errors.add(:agent_id, '角色为代理商时需要指定一个代理商') if self.role.present? && self.role.desc == 'agency' && self.agent_id.blank?
    errors.add(:agent_id, '非代理商时，请勿指定代理商') if self.role.present? && self.role.desc != 'agency' && self.agent_id.present?
  end



  def has_role? role
    self.role && self.role.desc == role
  end

  def view_projects
    projects = Project.includes(:owner, :audit).order('created_at desc')
    # 后台人员权限 可以查看所有项目
    # 大区经理和项目经理能查看当前架构所有的项目
    # 项目专员只能查看自己创建的项目
    # 超级管理员查看所有
    if ['regional_manager', 'project_manager'].include? self.role.desc
      projects.where('owner_id in (?)', self.organization.subtree.map(&:users).flatten.map(&:id))
    elsif ['super_admin', 'group_admin', 'normal_admin'].include? self.role.desc
      projects
    elsif 'project_user' == self.role.desc
      projects.where(owner_id: self.id)
    elsif 'agency' == self.role.desc
      #todo
      projects.where(agency_id: self.agent.id)
    else
      projects.where('1 = -1')
    end
  end

  def audit_projects
    status = 'none'
    case self.role.desc
    when 'project_manager'
      status = 'wait'
    when 'regional_manager'
      status = 'project_manager_audit'
    when 'normal_admin'
      status = 'regional_audit'
    end
    view_projects.where(project_status: status)
  end

  # todo查询待优化
  def view_orders
    Order.where('project_id in (?)', view_projects.collect{|p| p.id})
  end


  # 可查看的费用
  def view_costs
    costs = Cost.all
    if ['regional_manager', 'project_manager'].include? self.role.desc
      costs.where('user_id in (?)', self.organization.subtree.map(&:users).flatten.map(&:id))
    elsif ['super_admin', 'group_admin', 'normal_admin'].include? self.role.desc
      costs
    elsif 'project_user' == self.role.desc
      costs.where(user_id: self.id)
    else
      costs.where('1 = -1')
    end
  end


  def audit_orders
    status = 'none'
    case self.role.desc
    when 'project_manager'
      status = 'apply'
    when 'regional_manager'
      status = 'project_manager_audit'
    when 'normal_admin'
      status = 'regional_manager_audit'
    when 'group_admin'
      status = 'normal_admin_audit'
    end
    view_orders.where(order_status: status)
  end


  def audit_sample_orders
    audit_orders.where(order_type: 'sample')
  end

  def audit_bargains_orders
    audit_orders.where(order_type: 'bargains')
  end

  def audit_agents
    agents = Agent.includes(:apply_user).order('created_at desc')
    # 后台人员权限 审批所有代理商
    # 大区经理和项目经理能审批当前架构所有的代理商
    # 超级管理员查看所有
    if ['regional_manager', 'project_manager'].include? self.role.desc
      agents = agents.where('apply_id in (?)', self.organization.subtree.map(&:users).flatten.map(&:id))
    end
    status = 'none'
    case self.role.desc
    when 'project_manager'
      status = 'apply'
    when 'regional_manager'
      status = 'project_manager_audit'
    when 'normal_admin'
      status = 'regional_manager_audit'
    when 'group_admin'
      status = 'normal_admin_audit'
    end
    agents.where(agent_status: status)
  end

  # 是否是业务员
  def is_business?
    ['agency', 'project_user', 'project_manager', 'regional_manager'].include? self.role.desc
  end

  # 是否是后勤管理人员
  def is_rear?
    ['normal_admin', 'group_admin', 'super_admin'].include? self.role.desc
  end

  class << self
    # 业务人员
    def service_users
      joins(:role).where('roles.desc in (?)', ['regional_manager', 'project_manager', 'project_user'])
    end
  end


end
