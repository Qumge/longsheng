module ApplicationHelper
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

end
