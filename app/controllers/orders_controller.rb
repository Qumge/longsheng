class OrdersController < ApplicationController
  before_action :set_default_order, only: [:new, :create]
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  def new
    @order_product = OrderProduct.new
    render layout: false
  end


  def create
    @order_product = @order.order_products.new order_product_permit
    @flag = @order.save

  end

  def edit
    render layout: false
  end

  def update
    @flag = @order_product.update order_product_permit
  end

  def destroy
    if @order_product.destroy
      redirect_to project_path @project
    end
  end

  # TODO
  def place_order
    @order = Order.find_by id: params[:id]
    redirect_to projects_path, alert: '找不到数据' unless @order.present?
    @project = @order.project
  end

  private
  def set_default_order
    @project = current_user.view_projects.find_by id: params[:id]
    redirect_to projects_path, alert: '找不到数据' unless @project.present?
    if params[:order_id].present?
      @order = Order.where(id: params[:order_id], project: current_user.view_projects).first
    else
      @order = Order.new project_id: params[:id]
    end

  end

  def set_order
    @order_product = OrderProduct.find_by id: params[:id]
    redirect_to projects_path, alert: '找不到数据' unless @order_product.present?
    @project = @order_product.order.project
    redirect_to projects_path, alert: '找不到数据' unless current_user.view_projects.include? @project
  end

  def order_product_permit
    params.require(:order_product).permit(:product_id, :number)
  end
end
