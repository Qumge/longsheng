class DynamicReportsController < ApplicationController
  include DynamicReport

  def params
    {groups: ['users', 'projects'], select_columns: ['users.name', 'projects.name']}
  end
end
