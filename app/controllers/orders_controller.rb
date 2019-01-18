class OrdersController < ApplicationController
  before_action :set_default_order, only: [:new, :create]
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  def new
    @order_product = OrderProduct.new
    render layout: false

  end


  def create

  end

  def edit
    render layout: false
  end

  def update
    @flag = @order.update order_permit
  end

  def destroy
    if @order.destroy
    else
    end
  end

  private
  def set_default_order
    @project = Project.find_by id: params[:id]
    @order = Order.new project_id: params[:project_id]
  end

  def set_order
    @order = Order.find_by id: params[:id]
    # redirect_to contracts_path, alert: '找不到数据' unless @sale.present?
  end

  def order_permit
  end
end
