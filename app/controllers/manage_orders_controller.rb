class ManageOrdersController < ApplicationController
  include ApplicationHelper
  before_action :set_uptoken, only: [:index, :deliver]
  before_action :set_order, only: [:show, :deliver, :edit_payment, :update_payment]

  def index
    @orders = Order.search_conn(params).order('updated_at desc').page(params[:page]).per(Settings.per_page)
    response do |format|
      format.js
    end
  end

  def deliver
    @orders = Order.search_conn(params).order('updated_at desc').page(params[:page]).per(Settings.per_page)
    if @order.deliver_file.present?
      @order.deliver_file.update file_name: params[:file_name], path: params[:path]
    else
      @order.create_deliver_file file_name: params[:file_name], path: params[:path]
    end
    render template: 'manage_orders/index'
  end

  def show
    render layout: false
  end

  def edit_payment
    render layout: false
  end

  def update_payment
    @flag = @order.update payment: params[:order][:payment]
  end

  private
  def set_uptoken
    @uptoken = uptoken
  end

  def set_order
    @order = Order.find_by id: params[:id]
    redirect_to manage_orders_path unless @order.present?
  end

end
