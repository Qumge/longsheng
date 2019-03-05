class RecordReportsController < ApplicationController
  before_action :set_params
  include ReportData
  def index
    @orders_pie_labels = ["下单金额", "发货金额", "回款金额"]
    @orders_pie_data = format_order_pie

    @projects_pie_labels, @projects_pie_data = format_project_data_for_pie('payment')

    @categories_pie_labels, @categories_pie_data = format_category_data_for_pie('payment')

    @users_pie_labels, @users_pie_data = format_user_data_for_pie('payment')

    @costs_pie_labels, @costs_pie_data = format_cost_data_for_pie

  end


  def orders
    @orders_bar_labels, @orders_bar_data = format_order_bar
    @orders_bar_bars = ["下单金额", "发货金额", "回款金额"]
    @order_array = Kaminari.paginate_array(@orders_bar_labels).page(params[:page]).per(Settings.per_page)
  end


  def projects
    @projects_bar_labels, @projects_bar_bars, @projects_bar_data = format_category_bar 'payment'
    @projects_array = Kaminari.paginate_array(format_project_data_for_table 'payment').page(params[:page]).per(Settings.per_page)
    @applied_hash = project_data_for_table 'applied'
    @deliver_hash = project_data_for_table 'deliver'
  end


  def users
    #@projects_array = Kaminari.paginate_array(project_data_for_table 'payment').page(params[:page]).per(Settings.per_page)
    #@projects_bar_labels, @projects_bar_bars, @projects_bar_data = format_category_bar 'payment'
    @users_array = Kaminari.paginate_array(format_user_data_for_table 'payment').page(params[:page]).per(Settings.per_page)
    @applied_hash = user_data_for_table 'applied'
    @deliver_hash = user_data_for_table 'deliver'
  end

  def costs
    @costs_array = Kaminari.paginate_array(format_cost_data_for_table).page(params[:page]).per(Settings.per_page)
  end

  def invoices
    @invoices_array = Kaminari.paginate_array(format_invoice_data_for_table).page(params[:page]).per(Settings.per_page)
  end

end
