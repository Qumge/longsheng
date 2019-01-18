# == Schema Information
#
# Table name: order_products
#
#  id                   :integer          not null, primary key
#  discount             :float(24)
#  discount_price       :float(24)
#  discount_total_price :float(24)
#  number               :integer
#  price                :float(24)
#  total_price          :float(24)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  order_id             :integer
#  product_id           :integer
#

class OrderProduct < ActiveRecord::Base
end
