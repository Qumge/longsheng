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


  def preview_url
    Rails.application.config.qiniu_domain + '/' + path
  end
end
