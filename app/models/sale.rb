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
#  agent_id       :integer
#  contract_id    :integer
#  product_id     :integer
#

class Sale < ActiveRecord::Base
  belongs_to :product
  belongs_to :contract
  belongs_to :agent
  validates_presence_of :contract_id, :price, :product_id
  validates_numericality_of :price, if: proc{|sale| sale.price.present?}
  validates_uniqueness_of :product_id, scope: :contract_id


  class << self
    def default_sales
      Sale.where(agent_id: nil, contract_id: nil)
    end
  end
end
