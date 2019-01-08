class ProjectsController < ApplicationController

  def index

    @projects = current_user.view_projects
  end

  def new
    @project = Project.new
  end



end
