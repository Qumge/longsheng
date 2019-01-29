# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
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
#  organization_id        :integer
#  role_id                :integer
#
# Indexes
#
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
    else
      projects.where('1 = -1')
    end
  end

end
