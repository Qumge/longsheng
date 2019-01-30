# == Schema Information
#
# Table name: audits
#
#  id          :integer          not null, primary key
#  content     :string(255)
#  from_status :string(255)
#  model_type  :string(255)
#  status      :string(255)
#  to_status   :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  model_id    :integer
#  user_id     :integer
#

class Audit < ActiveRecord::Base
  belongs_to :project, foreign_key: :model_id
  scope :project_audit, -> {where(model_type: 'Project')}
  after_save :send_notify
  belongs_to :user

  PROJECT = []

  # 发送通知
  def send_notify

  end
end
