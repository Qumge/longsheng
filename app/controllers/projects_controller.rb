class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :upload, :update_agency]
  include ApplicationHelper
  def index
    @projects = current_user.view_projects.page(params[:page]).per(Settings.per_page)
  end

  def new
    @project = Project.new
  end

  def show
    @uptoken = uptoken
  end

  def create
    @project = Project.new
    @project.owner = current_user
    @project.create_user = current_user
    if @project.update project_permit
      redirect_to projects_path, notice: '已立项，等待审批'
    else
      render :new
    end
  end

  def update_agency

  end


  def upload
    @uptoken = uptoken
    @flag = true
    if ['project_contract', 'advance', 'plate'].include? params[:name]
      if @project.send(params[:name]).present?
        @flag = @project.send(params[:name]).update file_name: params[:file_name], path: params[:path]
      else
        @flag = @project.send("create_#{params[:name]}", {file_name: params[:file_name], path: params[:path]})
      end
    else
      @flag = false
    end
  end

  private
  def project_permit
    params.require(:project).permit(:name, :a_name, :category, :address, :city, :supplier_type, :strategic, :estimate,
                                    :butt_name, :butt_title, :butt_phone)
  end

  def set_project
    @project = current_user.view_projects.find_by_id params[:id]
    redirect_to projects_path, alert: '找不到这个项目' unless @project.present?
  end



end
