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
  belongs_to :project
  has_many :order_products

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
end
