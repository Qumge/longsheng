class TrainsController < ApplicationController
  before_action :set_train,  only: [:edit, :update, :destroy]
  before_action :set_uptoken, only: [:new, :create, :edit, :update]
  include ApplicationHelper

  def index
    @trains = Train.search_conn(params).page(params[:page]).per(Settings.per_page)
  end

  def new
    @train = Train.new
    render layout: false
  end

  def create
    @train = Train.new user: current_user
    @train.build_attachment path: params[:path], file_name: params[:file_name]
    @flag = @train.save
    render js: 'location.reload();'
  end

  def edit
    render layout: false
  end

  def update
    @train.user = current_user
    @train.build_attachment path: params[:path], file_name: params[:file_name]
    @flag = @train.save
    render js: 'location.reload();'
  end

  def destroy
    if @train.destroy
      redirect_to trains_path, notice: '删除成功'
    else
      redirect_to trains_path, alert: '删除失败'
    end
  end

  private
  def set_train
    @train = Train.find_by id: params[:id]
    redirect_to trains_path, alert: '找不到数据' unless @train.present?
  end

  def set_uptoken
    @uptoken = uptoken
  end

end
