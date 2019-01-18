# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  order_type :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :integer
#

class Order < ActiveRecord::Base
  belongs_to :product
  has_many :order_products
end
