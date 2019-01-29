# == Schema Information
#
# Table name: notices
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  model_type :string(255)
#  readed     :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  model_id   :integer
#  user_id    :integer
#

class Notice < ActiveRecord::Base

  TYPES = {
      project_need_audit: '有一个新立项的项目需要审核',
      project_audited: '您立项的的项目已经通过审核',
      project_failed_audit: '您立项的项目审核失败了',
      order_need_audit: '有一个样品礼品订单需要审核',
      order_audited: '您的样品、礼品申请已经通过审核'
  }


  class << self
    def create_notice type, id, user_id
      Notice.create model_type: type, model_id: id, content: TYPES[type], user_id: user_id
    end
  end

end
