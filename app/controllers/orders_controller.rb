class OrdersController < ApplicationController
  before_action :set_default_order, only: [:new, :create]
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  def new
    render layout: false
  end

  def show
    render layout: false
  end

  def create
    @flag = @order.update order_permit
    @orders = Sale.where(contract_id: params[:id])
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
    @order = Order.new contract_id: params[:id]
  end

  def set_sale
    @order = Order.find_by id: params[:id]
    # redirect_to contracts_path, alert: '找不到数据' unless @sale.present?
  end

  def sale_permit
  end
end
