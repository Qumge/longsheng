class DynamicReportsController < ApplicationController
  include DynamicReport

  before_action :set_params

  def payment
    params[:groups] ||= ['payment_logs']
    @datas = dynamic_payment_report.page(params[:page]).per(Settings.per_page)
  end

  def deliver
    params[:groups] ||= ['deliver_logs']
    @datas = dynamic_deliver_report.page(params[:page]).per(Settings.per_page)
  end

  def applied
    params[:groups] ||= ['order_products']
    @datas = dynamic_applied_report
  end


  def set_params
    params[:select_columns] ||= []
    params[:begin_date], params[:end_date] = params[:date_range].split(' - ') if params[:date_range].present?
    params[:begin_date] ||= DateTime.now
    params[:end_date] ||= DateTime.now
  end
end
