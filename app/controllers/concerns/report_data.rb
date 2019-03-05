module ReportData
  extend ActiveSupport::Concern
  ####################################### begin scope  #######################################
  def order_product_scope
    OrderProduct.joins({order: {project: :category}}, {product: :product_category})
  end

  def order_scope
    Order.joins({project: [:category, :owner]})
  end

  def cost_scope
    Cost.joins(:user)
  end

  def invoice_scope
    Invoice.joins(:user)
  end

  ############# end scope


  ####################################### begin search conn #######################################
  def search_conn
    search = ['1=1']
    if params[:project_id].present?
      search << "projects.id = #{params[:project_id]}"
    end
    if params[:product_category_id].present?
      search << "product_categories.id = #{params[:product_category_id]}"
    end
    if params[:category_id].present?
      search << "categories.id = #{params[:category_id]}"
    end
    if params[:user_id].present?
      search << "projects.owner_id = #{params[:user_id]}"
    end
    search.join ' and '
  end

  # 已下单where
  # type： deliver, applied, payment
  def order_type_conn type
    search = ['1=1']
    if params[:begin_date].present?
      begin_date = params[:begin_date].to_date.beginning_of_day
      search << "orders.#{type}_at >= '#{begin_date}'"
    end
    if params[:end_date].present?
      end_date = params[:end_date].to_date.end_of_day
      search << "orders.#{type}_at <= '#{end_date}'"
    end
    search.join ' and '
  end

  def cost_conn
    search = ['1=1']
    if params[:begin_date].present?
      begin_date = params[:begin_date].to_date.beginning_of_day
      search << "costs.occur_time >= '#{begin_date}'"
    end
    if params[:end_date].present?
      end_date = params[:end_date].to_date.end_of_day
      search << "costs.occur_time <= '#{end_date}'"
    end
    if params[:user_id].present?
      search << "costs.user_id = #{params[:user_id]}"
    end
    search.join ' and '
  end

  def invoice_conn
    search = ['1=1']
    if params[:begin_date].present?
      begin_date = params[:begin_date].to_date.beginning_of_day
      search << "invoices.sended_at >= '#{begin_date}'"
    end
    if params[:end_date].present?
      end_date = params[:end_date].to_date.end_of_day
      search << "invoices.sended_at <= '#{end_date}'"
    end
    if params[:user_id].present?
      search << "invoices.user_id = #{params[:user_id]}"
    end
    search.join ' and '
  end

  ####################################### end search conn #######################################


  ####################################### begin select #######################################
  def total_price
    'sum(orders.total_price) as total_price'
  end

  def total_payment
    'sum(orders.payment) as total_payment'
  end

  def total_cost
    # 'sum(costs.amount) as total_amount'
  end

  # def select_payment
  #   'total_price, payment_at'
  # end
  ####################################### end select ########################################



  ####################################### begin  data #######################################
  def order_data type
    order_scope.where(search_conn).where(order_type_conn type)
  end

  def cost_data
    cost_scope.where(cost_conn)
  end

  def invoice_data
    invoice_scope.where(invoice_status: 'sended').where(invoice_conn)
  end

  ####################################### begin  data #######################################


  ####################################### begin chat data #######################################
  def order_data_for_pie type
    if type == 'payment'
      order_data(type).select(total_payment).first.total_payment.to_f
    else
      order_data(type).select(total_price).first.total_price.to_f
    end
  end

  def project_data_for_pie type
    order_data = order_data type
    # {project1 => [order1, order2], project2 => [order3, order4]}
    group_data = order_data.group_by{|order| order.project}
    datas = {}
    group_data.each do |project, orders|
      datas[project] = orders.sum{|order| order.payment}
    end
    datas
  end

  def category_data_for_pie type
    project_datas = project_data_for_pie type
    group_data = project_datas.group_by{|project, data| project.category}
    datas = {}
    group_data.each do |category, project_data|
      datas[category] = project_data.sum{|project, data| data}
    end
    datas
  end

  def user_data_for_pie type
    project_datas = project_data_for_pie type
    group_data = project_datas.group_by{|project, data| project.owner}
    datas = {}
    group_data.each do |user, project_data|
      datas[user] = project_data.sum{|project, data|  data}
    end
    datas
  end

  def cost_data_for_pie
    cost_datas = cost_data
    group_data = cost_datas.group_by{|cost, data| cost.user}
    datas = {}
    group_data.each do |user, cost_data|
      datas[user] = cost_data.sum{| data| data.amount}
    end
    datas
  end

  ###############bar
  def order_data_for_bar type
    data = order_data(type)
    data.group_by do |d|
      simple_date_time d.send("#{type}_at")
    end
  end

  #{date: {category: 1}}
  def category_data_for_bar type
    data = order_data(type)
    date_datas = data.group_by do |d|
      simple_date_time d.send("#{type}_at")
    end
    date_datas_hash = {}
    date_datas.each do |date, orders|
      order_datas_hash = {}
      orders.group_by{|order| order.project.category}.each do |category, orders|
        amount = 0
        orders.each do |order|
          amount += order.send("#{type == 'payment' ? 'payment' : 'total_price'}").to_f
        end
        order_datas_hash[category] = amount
      end
      date_datas_hash[date] = order_datas_hash
    end
    date_datas_hash
  end

  #############table
  def project_data_for_table type='payment'
    data = order_data(type)
    date_datas = data.group_by do |d|
      simple_date_time d.send("#{type}_at")
    end
    date_datas_hash = {}
    date_datas.each do |date, orders|
      order_datas_hash = {}
      orders.group_by{|order| order.project}.each do |project, orders|
        amount = 0
        orders.each do |order|
          amount += order.send("#{type == 'payment' ? 'payment' : 'total_price'}").to_f
        end
        order_datas_hash[project] = amount
      end
      date_datas_hash[date] = order_datas_hash
    end
    date_datas_hash
  end

  def user_data_for_table type='payment'
    data = order_data(type)
    date_datas = data.group_by do |d|
      simple_date_time d.send("#{type}_at")
    end
    date_datas_hash = {}
    date_datas.each do |date, orders|
      order_datas_hash = {}
      orders.group_by{|order| order.project.owner}.each do |owner, orders|
        amount = 0
        orders.each do |order|
          amount += order.send("#{type == 'payment' ? 'payment' : 'total_price'}").to_f
        end
        order_datas_hash[owner] = amount
      end
      date_datas_hash[date] = order_datas_hash
    end
    date_datas_hash
  end

  def cost_data_for_table
    date_datas_hash = {}
    date_datas = cost_data.group_by{|cost| simple_date_time cost.occur_time}
    date_datas.each do |date, costs|
      cost_datas_hash = {}
      costs.group_by{|cost| cost.user}.each do |user, user_costs|
        amount = 0
        user_costs.each do |cost|
          amount += cost.amount
        end
        cost_datas_hash[user] = amount
      end
      date_datas_hash[date] = cost_datas_hash
    end
    date_datas_hash
  end

  def invoice_data_for_table
    date_datas_hash = {}
    date_datas = invoice_data.group_by{|invoice| simple_date_time invoice.sended_at}
    date_datas.each do |date, invoices|
      invoice_datas_hash = {}
      invoices.group_by{|invoice| invoice.user}.each do |user, user_invoices|
        amount = 0
        user_invoices.each do |invoice|
          amount += invoice.amount
        end
        invoice_datas_hash[user] = amount
      end
      date_datas_hash[date] = invoice_datas_hash
    end
    p date_datas_hash, 111111111111
    date_datas_hash
  end
  ####################################### end chat data #######################################



  ####################################### format chat data####################################
  def format_order_pie
    data = []
    ['applied', 'deliver', 'payment'].each do |type|
      data << order_data_for_pie(type)
    end
    data
  end

  def format_project_data_for_pie type = 'payment'
    projects_datas = project_data_for_pie(type)
    projects_pie_labels = projects_datas.collect{|project, data| project.name}[0..10]
    projects_pie_data = projects_datas.collect{|project, data| data}[0..10]
    return projects_pie_labels, projects_pie_data
  end

  def format_category_data_for_pie type = 'payment'
    category_datas = category_data_for_pie(type)
    categories_pie_labels = category_datas.collect{|category, data| category.name}[0..10]
    categories_pie_data = category_datas.collect{|category, data| data}[0..10]
    return categories_pie_labels, categories_pie_data
  end

  def format_user_data_for_pie type = 'payment'
    users_datas = user_data_for_pie(type)
    users_pie_labels = users_datas.collect{|user, data| user.name}[0..10]
    users_pie_data = users_datas.collect{|user, data| data}[0..10]
    return users_pie_labels, users_pie_data
  end

  def format_cost_data_for_pie
    costs_datas = cost_data_for_pie
    costs_pie_labels = costs_datas.collect{|user, data| user.name}[0..10]
    costs_datas_pie_data = costs_datas.collect{|user, data| data}[0..10]
    return costs_pie_labels, costs_datas_pie_data
  end


  ### bar
  def format_order_bar type='payment'
    labels = data_label
    datas = []
    ['applied', 'deliver', 'payment'].each do |type|
      bar_data = []
      data = order_data_for_bar(type)
      labels.each do |label|
        price = 0
        if data[label].present?
          data[label].each do |d|
            price += d.send("#{type == 'payment' ? 'payment' : 'total_price'}").to_f
          end
        end
        bar_data << price
      end
      datas << bar_data
    end
    return labels, datas
  end

  def format_category_bar type='payment'
    labels = data_label
    datas = []
    data = category_data_for_bar(type)
    bars = []

    data_label.each_with_index do |date, index|
      bar_data = []
      bars = []
      Category.all.each do |category|
        amount = 0
        amount = data[date][category].to_f if data[date].present? && data[date][category].present?
        bar_data << amount
        bars << category.name
      end
      datas << bar_data
    end
    return labels, bars, format_arr(datas)
  end


  def format_project_data_for_table type='payment'
    datas = []
    data = project_data_for_table type
    data_label.each do |date|
      project_hash = {}
      projects = Project.all
      projects = projects.where(id: params[:project_id]) if params[:project_id].present?
      projects.each do |project|
        amount = 0
        amount = data[date][project] if data[date].present? && data[date][project].present?
        project_hash[project] = amount
      end
      datas << {date => project_hash}
    end
    datas
  end
  #
  def format_user_data_for_table type='payment'
    datas = []
    data = user_data_for_table type
    users = User.all
    users = User.where(id: params[:user_id]) if params[:user_id].present?
    data_label.each do |date|
      user_hash = {}
      users.each do |user|
        amount = 0
        amount = data[date][user] if data[date].present? && data[date][user].present?
        user_hash[user] = amount
      end
      datas << {date => user_hash}
    end
    datas
  end

  def format_cost_data_for_table
    datas = []
    data = cost_data_for_table
    users = User.all
    users = User.where(id: params[:user_id]) if params[:user_id].present?
    data_label.each do |date|
      users.each do |user|
        amount = 0
        amount = data[date][user] if data[date].present? && data[date][user].present?
        datas << [date, user, amount]
      end
    end
    datas
  end

  def format_invoice_data_for_table
    datas = []
    data = invoice_data_for_table
    users = User.all
    users = User.where(id: params[:user_id]) if params[:user_id].present?
    data_label.each do |date|
      users.each do |user|
        amount = 0
        amount = data[date][user] if data[date].present? && data[date][user].present?
        datas << [date, user, amount]
      end
    end
    p datas, 11111111111
    datas
  end


  ################helper#######
  def simple_date_time datetime
    group_type = params[:group_type]
    if datetime.present?
      if group_type == 'day'
        datetime.strftime('%Y年%m月%d日')
      elsif group_type == 'month'
        datetime.strftime('%Y年%m月')
      else
        datetime.strftime('%Y年')
      end
    end

  end


  def data_label
    begin_date = params[:begin_date].to_date.beginning_of_day
    end_date = params[:end_date].to_date.end_of_day
    begin_date.to_date.upto(end_date.to_date).group_by{|date| simple_date_time date}.keys
  end

  def set_params
    params[:group_type] ||= 'day'
    if params[:date_range].present?
      arr = params[:date_range].split(' - ')
      params[:begin_date] = arr[0].to_date
      params[:end_date] = arr[1].to_date
    else
      params[:begin_date] ||= DateTime.now
      params[:end_date] = DateTime.now
      params[:date_range] = "#{params[:begin_date].strftime('%Y-%m-%d')} - #{params[:end_date].strftime('%Y-%m-%d')}"
    end

  end

  def format_arr arrs
    new_array = Array.new(arrs[0].size) { Array.new(arrs.size, 0) }
    arrs.each_with_index do |arr, i|
      arr.each_with_index do |str, index|
        new_array[index][i] = str
      end
    end
    new_array
  end
end