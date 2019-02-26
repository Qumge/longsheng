RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  config.current_user_method(&:current_user)
  ## == Devise ==
  config.authenticate_with do
    # authenticate_admin_user!
    # warden.authenticate! scope: :user
  end

  ## == Cancan ==
  # config.authorize_with :cancan
  config.authorize_with :cancancan
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
  config.included_models = ["Resource", 'Role', 'User', 'Organization', 'Company', 'Category']

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
    field :title
    field :name do
      label '姓名'
    end
    field :organization do
      associated_collection_cache_all true  # REQUIRED if you want to SORT the list as below
      label '组织'
    end
    field :roles do
      associated_collection_cache_all true  # REQUIRED if you want to SORT the list as below
      label '角色'
    end
    field :agent do
      associated_collection_cache_all true  # REQUIRED if you want to SORT the list as below
      label '代理商'
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
    field :name do
      label '说明'
    end
    field :action do
      label '操作'
    end
    field :target do
      label '模块'
    end
  end

  config.model 'Organization' do
    label '组织架构'
    label_plural "组织架构"
    field :name do
      label '组织名'
    end
    nestable_tree({
                      live_update: :only
                  })

  end

  config.model 'Company' do
    label_plural "战略合作方"
    field :name do
      label '公司名'
    end
    field :desc do
      label '简介'
    end
  end

  config.model 'Category' do
    label_plural "产品品类"
    field :name do
      label '品类名'
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
    # Add the nestable action for configured models
    nestable
  end
end
