module ApplicationHelper

  def uptoken

    put_policy = Qiniu::Auth::PutPolicy.new(
        "zxyheyen",                    # 存储空间
        nil,                           # 最终资源名，可省略，即缺省为“创建”语义
        1800,                          # 相对有效期，可省略，缺省为3600秒后 uptoken 过期
        (Time.now + 30.minutes).to_i  # 绝对有效期，可省略，指明 uptoken 过期期限（绝对值），通常用于调试，这里表示半小时
    )

    uptoken = Qiniu::Auth.generate_uptoken(put_policy) #生成凭证

  end

  def simple_time datetime
    datetime.strftime('%Y-%m-%d')if datetime.present?
  end


  def get_title params
    title_config[params[:controller].to_sym].present? ? title_config[params[:controller].to_sym][params[:action].to_sym] : ''
  end

  def title_config
    {
        projects: {
            index: '项目列表',
            new: '立项',
            create: '立项',
            show: '详情'
        },
        contracts: {
            index: '战略合同列表',
            new: '添加合同',
            create: '添加合同',
            show: '详情',
            edit: '合同编辑',
            update: '合同编辑'
        }
    }
  end

  def show_link(object, content, options = {})
    link_to(content, object, options) if can?(:read, object)
  end

  def edit_link(object, content, options = {})
    link_to(content, [:edit, object], options) if can?(:update, object)
  end

  def destroy_link(object, content, options = {})
    link_to(content, object, options.merge({:confirm => "确定删除吗?", :method => :delete})) if can?(:destroy, object)
  end

  def create_link(object, content, options = {})
    if can?(:create, object)
      object_class = (object.kind_of?(Class) ? object : object.class)
      link_to(content, [:new, object_class.name.underscore.to_sym], options)
    end
  end

  def active_class params, controller, action=nil
    if action.present?
      params[:controller] == controller && params[:action] == action ? 'active' : ''
    else
      params[:controller] == controller ? 'active' : ''
    end

  end

end
