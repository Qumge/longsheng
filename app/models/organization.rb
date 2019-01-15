# == Schema Information
#
# Table name: organizations
#
#  id         :integer          not null, primary key
#  ancestry   :string(255)
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_organizations_on_ancestry  (ancestry)
#

class Organization < ActiveRecord::Base
  has_ancestry
  has_many :users



end
