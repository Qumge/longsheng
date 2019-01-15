# == Schema Information
#
# Table name: projects
#
#  id            :integer          not null, primary key
#  city          :string(255)
#  category      :string(255)
#  a_name        :string(255)
#  name          :string(255)
#  address       :string(255)
#  supplier_type :string(255)
#  strategic     :boolean
#  estimate      :integer
#  butt_name     :string(255)
#  butt_title    :string(255)
#  butt_phone    :string(255)
#  owner_id      :integer
#  create_id     :integer
#  agency_id     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Project < ActiveRecord::Base
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  belongs_to :create_user, class_name: 'User', foreign_key: :create_id
  has_one :audit, -> {where(model_type: 'Project')}, foreign_key: :model_id
  after_create :create_audit
  validates_presence_of :name, :a_name, :category, :address, :city, :supplier_type
  validates_numericality_of :estimate, if: Proc.new{|p| p.estimate.present?}

  # 根据审核表获取当前的审核状态
  def status
    ''
  end

  def contract

  end

  private
  def create_audit
    Audit.create model_id: self.id, model_type: self.class.name
  end
end
