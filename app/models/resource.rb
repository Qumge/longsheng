class Resource < ActiveRecord::Base
  has_and_belongs_to_many :roles, join_table: 'role_resources'
  validates_presence_of :target, :action
end
