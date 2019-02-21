module ApplicationHelper

  def uptoken

    put_policy = Qiniu::Auth::PutPolicy.new(
        "longsheng",                    # 存储空间
        nil,                           # 最终资源名，可省略，即缺省为“创建”语义
        1800,                          # 相对有效期，可省略，缺省为3600秒后 uptoken 过期
        (Time.now + 30.minutes).to_i  # 绝对有效期，可省略，指明 uptoken 过期期限（绝对值），通常用于调试，这里表示半小时
    )

    uptoken = Qiniu::Auth.generate_uptoken(put_policy) #生成凭证

  end

  def simple_time datetime
    datetime.strftime('%Y-%m-%d')if datetime.present?
  end

  def simple_time_mini datetime
    datetime.strftime('%Y-%m-%d %H:%M:%S')if datetime.present?
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
            show: '详情',
            agent: '代理商',
            report: '项目报备',
            sales: '价格体系'
        },
        contracts: {
            index: '战略合同列表',
            new: '添加合同',
            create: '添加合同',
            show: '详情',
            edit: '合同编辑',
            update: '合同编辑'
        },
        audits: {
            index: '审批操作台',
            orders: '样品、礼品审批',
            sales: '特价审批',
            agents: '代理审批',
            invoices: '开票审批'
        },
        manage_orders: {
            index: '订单列表'
        },
        agents: {
            index: '代理商列表',
            new: '代理商申请',
            create: '代理商申请'
        },
        products: {
            index: '产品列表',
            new: '添加产品',
            create: '添加产品',
            edit: '修改产品',
            update: '修改产品'
        },
        costs: {
            index: '费用列表',
            new: '添加费用',
            create: '添加费用',
            edit: '修改费用',
            update: '修改费用'
        },
        notices: {
            index: '消息列表'
        },
        trains: {
            index: '培训资料列表'
        },
        competitors: {
            index: '竞品信息列表'
        }
    }
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


  def redirect_path notice
    case notice.model_type
    when 'project_need_audit'
      projects_audits_path
    when 'project_audited'
      project_path notice.model_id
    when 'project_failed_audit'
      project_path notice.model_id
    when 'sample_order_need_audit'
      orders_audits_path
    when 'sample_order_audited'
      project_path notice.order.project
    when 'sample_order_failed_audit'
      project_path notice.order.project
    when 'bargains_order_need_audit'
      bargains_audits_path
    when 'bargains_order_audited'
      project_path notice.order.project
    when 'bargains_order_failed_audit'
      project_path notice.order.project
    when 'order_deliver'
      manage_orders_path
    when 'order_sign'
      project_path notice.order.project
    when 'agent_need_audit'
      agents_audits_path
    when 'agent_audited'
      agents_path
    when 'agent_failed_audit'
      agents_path
    when 'invoice_need_audit'
      invoices_audits_path
    when 'invoice_failed'
      project_path notice.invoice.project
    when 'invoice_applied'
      project_path notice.invoice.project
    when 'invoice_need_send'
      invoices_audits_path
    when 'invoice_sended'
      project_path notice.invoice.project
    end
  end

  def show_file_name default_name, file
    file.file_name.size > 10 ? "#{default_name}_#{simple_time file.created_at}" : file.file_name
  end

end
