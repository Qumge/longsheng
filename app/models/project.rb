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

  private
  def create_audit
    Audit.create model_id: self.id, model_type: self.class.name
  end
end
