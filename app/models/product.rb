# == Schema Information
#
# Table name: products
#
#  id              :integer          not null, primary key
#  deleted_at      :datetime
#  name            :string(255)
#  no              :string(255)
#  product_no      :string(255)
#  reference_price :float(24)
#  unit            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_products_on_deleted_at  (deleted_at)
#

class Product < ActiveRecord::Base
  has_many :sales
  has_many :order_products
  has_one :sale, ->(sale) { where("project_id = ?", sale.project_id) }
  validates_presence_of :no, :product_no, :name, :reference_price
  validates_uniqueness_of :no, if: proc{|product| product.no.present?}


  def default_price project
    price = self.reference_price
    if project.contract.present?
      sale = project.contract.sales.find_by(product_id: self.id)
      price = sale.price if sale.present?
    end
    price
  end

end
