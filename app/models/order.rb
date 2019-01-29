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
  has_many :order_invoices
  has_and_belongs_to_many :invoices, join_table: "order_invoices"
  has_one :place, -> {where(model_type: 'place')}, class_name: 'Attachment', foreign_key: :model_id
  has_one :deliver, -> {where(model_type: 'deliver')}, class_name: 'Attachment', foreign_key: :model_id
  has_one :sign, -> {where(model_type: 'sign')}, class_name: 'Attachment', foreign_key: :model_id

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

  # TODO
  def can_edit?
    self.project.can_do? :order
  end


end
