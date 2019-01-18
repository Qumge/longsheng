# == Schema Information
#
# Table name: projects
#
#  id            :integer          not null, primary key
#  a_name        :string(255)
#  address       :string(255)
#  butt_name     :string(255)
#  butt_phone    :string(255)
#  butt_title    :string(255)
#  category      :string(255)
#  city          :string(255)
#  estimate      :integer
#  name          :string(255)
#  strategic     :boolean
#  supplier_type :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  agency_id     :integer
#  create_id     :integer
#  owner_id      :integer
#

class Project < ActiveRecord::Base
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  belongs_to :create_user, class_name: 'User', foreign_key: :create_id
  has_one :audit, -> {where(model_type: 'Project')}, foreign_key: :model_id
  after_create :create_audit
  validates_presence_of :name, :a_name, :category, :address, :city, :supplier_type
  validates_numericality_of :estimate, if: Proc.new{|p| p.estimate.present?}
  has_one :project_contract, -> {where(model_type: 'contract')}, class_name: 'Attachment', foreign_key: :model_id
  has_one :advance, -> {where(model_type: 'advance')}, class_name: 'Attachment', foreign_key: :model_id
  has_one :plate, -> {where(model_type: 'plate')}, class_name: 'Attachment', foreign_key: :model_id

  # 根据审核表获取当前的审核状态
  def status
    ''
  end
  

  private
  def create_audit
    Audit.create model_id: self.id, model_type: self.class.name
  end
end
