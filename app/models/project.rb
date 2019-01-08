class Project < ActiveRecord::Base
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  has_one :audit, -> {where(model_type: 'Project')}
  after_create :create_audit

  private
  def create_audit
    Audit.create model_id: self.id, model_type: self.class.name
  end
end
