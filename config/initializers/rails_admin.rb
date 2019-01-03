RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)
  ## == Devise ==
  config.authenticate_with do
    # authenticate_admin_user!
    # warden.authenticate! scope: :user
  end

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  #config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true
  #
  config.main_app_name = ["龙胜", "工程"]
  config.included_models = ["Resource", 'Role', 'User']

  config.model 'User' do
    label_plural "用户"
    field :login do
      label '账号'
    end
    field :email do
      label '邮箱'
    end
    field :password do
      label '密码'
    end
    field :name do
      label '姓名'
    end
    field :role do
      associated_collection_cache_all true  # REQUIRED if you want to SORT the list as below
      label '角色'
    end
  end

  config.model 'Role' do
    label_plural "角色"
    field :name do
      label '角色名'
    end
    field :desc  do
      label '说明'
    end
    field :resources do
      associated_collection_cache_all true
      label '权限'
    end
  end

  config.model 'Resource' do
    label_plural "权限资源"
    field :desc do
      label '说明'
    end
    field :action do
      label '操作'
    end
    field :target do
      label '模块'
    end
  end



  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
