class Audit < ActiveRecord::Base
  belongs_to :project, foreign_key: :model_id
  scope :project_audit, -> {where(model_type: 'Project')}
  after_save :send_notify

  PROJECT = []

  # 发送通知
  def send_notify

  end
end
