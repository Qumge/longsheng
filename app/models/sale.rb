# == Schema Information
#
# Table name: sales
#
#  id          :integer          not null, primary key
#  desc        :string(255)
#  price       :float(24)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  contract_id :integer
#  product_id  :integer
#

class Sale < ActiveRecord::Base
  belongs_to :product
  belongs_to :contract
end
