# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  desc       :string(255)
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Role < ActiveRecord::Base
  has_and_belongs_to_many :resources, join_table: 'role_resources'
  validates_presence_of :name
  ROLES = {super_admin: '超级管理员', group_admin: '部门管理员', normal_admin: '后勤管理专员', regional_manager: '大区总监',
           project_manager: '项目经理', project_user: '项目专员', agency: '代理商'}

  class << self
    def load_default_roles
      ROLES.each do |key, value|
        Role.create name: value, desc: key unless Role.find_by(name: key).present?
      end
    end
  end
end
