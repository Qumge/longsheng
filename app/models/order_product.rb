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
  belongs_to :product
  belongs_to :order
  validates_presence_of :number, :product_id
  before_save :set_price
  validates_numericality_of :number, only_integer: true, greater_than: 0, if: ->(order_project) { order_project.number.present? }

  def real_price
    discount_price.present? ? discount_price : price
  end

  def real_total_price
    discount_total_price.present? ? discount_total_price : total_price
  end

  def sale
    self.product.sale self.order.project
  end

  def set_price
    self.price = sale.price
    p sale.price
    self.total_price = sale.price * number
    self.discount = sale.discount
    self.discount_price = sale.discount_price
    self.discount_total_price = sale.discount_price * number if sale.discount_price.present?
  end

end
