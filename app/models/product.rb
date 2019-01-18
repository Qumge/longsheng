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


  # 价格体系
  def discount_price project_id
    project = Project.find_by id: project_id
    contract = project.contract
    # 不存在战略合同的额情况 TODO
    if contract.present?
      # 没有价格体系的情况 TODO
      if contract.sales.present?
        contract.sales.find_by product: self
      end
    end
  end
end
