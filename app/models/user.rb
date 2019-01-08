class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :role
  belongs_to :organization
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
