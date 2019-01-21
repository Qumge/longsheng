# == Schema Information
#
# Table name: sales
#
#  id             :integer          not null, primary key
#  desc           :string(255)
#  discount       :float(24)
#  discount_price :float(24)
#  price          :float(24)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  contract_id    :integer
#  product_id     :integer
#

class Sale < ActiveRecord::Base
  belongs_to :product
  belongs_to :contract
  validates_presence_of :contract_id, :price, :product_id
  validates_numericality_of :price, if: proc{|sale| sale.price.present?}
  validates_uniqueness_of :product_id, scope: :contract_id
end
