# == Schema Information
#
# Table name: invoices
#
#  id         :integer          not null, primary key
#  no         :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :integer
#  user_id    :integer
#

class Invoice < ActiveRecord::Base
  has_and_belongs_to_many :orders, join_table: "order_invoices"
  has_many :order_invoices
  belongs_to :project

  def can_invoice_orders
    project = self.project
    project.orders.where('orders.id not in (?)', project.order_invoices.collect{|o| o.order_id} - self.order_invoices.collect{|o| o.order_id})
  end

  def invoice_no
    '#NO.' + id.to_s.rjust(6, '0')
  end
end
