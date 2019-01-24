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
    busy_order_invoices = self.project.order_invoices.where('invoice_id != ?', self.id)
    free_orders = project.orders
    free_orders = free_orders.where('orders.id not in (?)', busy_order_invoices.collect{|order_invoices| order_invoices.id}) if busy_order_invoices.present?
    free_orders
  end

  def invoice_no
    '#NO.' + id.to_s.rjust(6, '0')
  end

  def can_edit?
    project.can_do? :invoice
  end
end
