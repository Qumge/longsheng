# == Schema Information
#
# Table name: audits
#
#  id         :integer          not null, primary key
#  model_id   :integer
#  model_type :string(255)
#  status     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Audit < ActiveRecord::Base
  belongs_to :project, foreign_key: :model_id
  scope :project_audit, -> {where(model_type: 'Project')}
  after_save :send_notify

  PROJECT = []

  # 发送通知
  def send_notify

  end
end
