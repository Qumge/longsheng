# == Schema Information
#
# Table name: role_resources
#
#  id          :integer          not null, primary key
#  role_id     :integer
#  resource_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class RoleResource < ActiveRecord::Base
end
