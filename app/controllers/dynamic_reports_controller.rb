class DynamicReportsController < ApplicationController
  include DynamicReport

  before_action :set_params

  def payment
    dynamic_payment_report
  end

  def deliver
    dynamic_deliver_report
  end

  def applied
    dynamic_applied_report
  end


  def set_params
    params.merge!({groups: ['users', 'projects'], select_columns: ['users.name', 'projects.name']})
  end
end
