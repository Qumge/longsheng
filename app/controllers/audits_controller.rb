class AuditsController < ApplicationController

  before_action :set_model, only: [:success, :failed, :failed_notice]

  def index

  end

  def projects
    @projects = current_user.audit_projects.page(params[:page]).per(Settings.per_page)
  end

  def orders
    @orders = current_user.audit_sample_orders.page(params[:page]).per(Settings.per_page)
  end


  def bargains
    @orders = current_user.audit_bargains_orders.page(params[:page]).per(Settings.per_page)
  end

  def agents
    @agents = current_user.audit_agents.page(params[:page]).per(Settings.per_page)
  end

  def audits
    @audits = current_user.audits.order('created_at desc').page(params[:page]).per(Settings.per_page)
  end

  def success
    from_status = @model.send(@status_column)
    begin
      @model.send("do_#{current_user.role.desc}_audit")
      @model.save
      Audit.create model_id: @model.id, model_type: @model.class.name, from_status: from_status, to_status: @model.send(@status_column), user: current_user
      redirect_to @url, notice: '已审批'
    rescue => e
      p  e
    end

  end

  def failed_notice
    @audit = Audit.new model_id: @model.id, model_type: @model.class.name
    render layout: false
  end

  def failed
    from_status = @model.send(@status_column)
    begin
      @model.do_failed
      @model.save
      Audit.create model_id: @model.id, model_type: @model.class.name, from_status: from_status, to_status: @model.send(@status_column), content: params[:audit][:content], user: current_user
      render json: {status: 'success'}
    rescue => e
      p e
    end

  end

  private
  def set_model
    if params[:type] == 'Project'
      @model = current_user.audit_projects.where(id: params[:id]).first
      @status_column = 'project_status'
      @url = projects_audits_path
    elsif params[:type] == 'Order'
      @model = current_user.audit_orders.where(id: params[:id]).first
      @status_column = 'order_status'
      @url = @model.order_type == 'sample' ? orders_audits_path : bargains_audits_path
    elsif params[:type] == 'Agent'
      @model = current_user.audit_agents.where(id: params[:id]).first
      @status_column = 'agent_status'
      @url = agents_audits_path
    end
    redirect_to audits_path, alert: '找不到数据' unless @model.present?
  end


end
