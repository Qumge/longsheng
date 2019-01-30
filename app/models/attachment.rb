# == Schema Information
#
# Table name: attachments
#
#  id         :integer          not null, primary key
#  file_name  :string(255)
#  model_type :string(255)
#  path       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  model_id   :integer
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
      order.deliver if order.present? && order.active?
    elsif self.model_type == 'sign'
      order = Order.find_by id: model_id
      order.sign if order.present? && order.deliver?
    end

  end


end
