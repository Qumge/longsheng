class InvoicesController < ApplicationController
  before_action :set_default_invoice, only: [:new, :create]
  before_action :set_invoice, only: [:edit, :update]

  def new
    @orders = @project.can_invoice_orders
    render layout: false
  end

  def create
    orders = []
    if params[:order].present?
      params[:order].each do |key, val|
        order = Order.find_by id: key
        orders << order if order.present? && order.invoices.blank?
      end
      @invoice.orders = orders
      @invoice.save
    end
  end

  def edit
    render layout: false
  end

  def update
    orders = []
    params[:order].each do |key, val|
      order = Order.find_by id: key
      orders << order if order.present? && (order.invoices.blank? || order.invoices.include?(@invoice))
    end
    @invoice.orders = orders
    @invoice.save
  end

  private
  def set_default_invoice
    @project = current_user.view_projects.find_by id: params[:id]
    redirect_to projects_path, alert: '找不到数据' unless @project.present?
    if params[:invoice_id].present?
      @invoice = Invoice.where(id: params[:invoice_id], project: current_user.view_projects).first
    else
      @invoice = Invoice.new project_id: params[:id]
    end

  end

  def set_invoice
    @project = current_user.view_projects.find_by id: params[:id]
    @invoice = Invoice.find_by id: params[:invoice_id]
    redirect_to projects_path, alert: '找不到数据' unless @invoice.present? && @project.present?
    @orders = @invoice.can_invoice_orders
  end
end
