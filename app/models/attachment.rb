# == Schema Information
#
# Table name: attachments
#
#  id         :integer          not null, primary key
#  deleted_at :datetime
#  file_name  :string(255)
#  model_type :string(255)
#  path       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  model_id   :integer
#
# Indexes
#
#  index_attachments_on_deleted_at  (deleted_at)
#

class Attachment < ActiveRecord::Base

  after_create :do_order

  def preview_url
    Rails.application.config.qiniu_domain + '/' + path
  end

  # 上传完图片后 执行order的操作
  def do_order
    # 发货清单 上传后表示已经发货
    if self.model_type == 'deliver'
      order = Order.find_by id: model_id
      order.do_deliver! if order.may_do_deliver?
    elsif self.model_type == 'sign'
      order = Order.find_by id: model_id
      order.do_sign! if order.may_do_sign?
    elsif self.model_type == 'invoice'
      invoice = Invoice.find_by id: model_id
      invoice.do_sended! if invoice.may_do_sended?
    end

  end


end
