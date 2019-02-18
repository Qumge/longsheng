class NoticesController < ApplicationController

  def index
    @notices = current_user.notices.order('readed').order('created_at desc').page(params[:page]).per(Settings.per_page)
  end

  def check
    @notice = Notice.find_by id: params[:id]
    if params[:type] == 'view'
      @notice.update readed: true unless @notice.readed
    else
      @notice.update readed: !@notice.readed
    end

  end

end
