# == Schema Information
#
# Table name: products
#
#  id              :integer          not null, primary key
#  no              :string(255)
#  product_no      :string(255)
#  unit            :string(255)
#  reference_price :float(24)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  name            :string(255)
#

class Product < ActiveRecord::Base
  has_many :sales
end
