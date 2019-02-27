class Import::OrderImporter < ActiveImporter::Base
  imports Product
  imports Order
  imports OrderProduct
  imports Sale
  transactional

  on :import_started do
    @row_count = 2
    @normal_order = Order.create project: params[:project], user: params[:user], order_type: 'normal'
    @bargains_order = Order.create project: params[:project], user: params[:user], order_type: 'bargains'
    logger.info "开始导入订单信息信息...."
  end
  column '产品代码'
  column '产品名'
  column '数量'
  column '战略价'
  column '单价（特价）'
  column '金额'
  column '备注/特殊要求'



  fetch_model do
    product = Product.find_by no: row['产品代码']
    raise "第#{row_count}行 #{row['产品代码']}不存在。" unless product.present?
    raise "第#{row_count}行 【数量】不存在。" unless row['数量'].present? && row['数量'].to_i > 0
    raise "第#{row_count}行 【战略价】或【单价（特价）】不存在。" unless row['战略价'].present? || row['单价（特价）'].present?
    raise "第#{row_count}行 【金额】不存在。" unless row['金额'].present?
    product
  end

  on :row_processing do
    project = params[:project]
    product = model
    if row['战略价'].present?
      sale = Sale.find_by product: product, contract: project.contract
      raise "第#{row_count}行 战略价不存在或与系统内的战略价不匹配" unless sale.present? && sale.price == row['战略价'].to_f
      price = sale.price
      order = @normal_order
      @normal_order.desc = "#{@normal_order.desc}#{row['备注/特殊要求']}; "
      order
    else
      price = row['单价（特价）'].to_f
      order = @bargains_order
      @bargains_order.desc = "#{@bargains_order.desc}#{row['备注/特殊要求']}; "
    end
    number = row['数量'].to_i
    total_price = number * price
    raise "第#{row_count}行 【金额】计算不正确。" unless  row['金额'].to_f == total_price
    order_product = OrderProduct.new order: order, product: product, number: number, price: product.default_price(project), total_price: number * product.default_price(project),
                             discount_price: price, discount_total_price: total_price
    unless order_product.save
      error = product.errors.messages.first
      raise "第#{row_count}行 #{I18n.t "activerecord.attributes.product.#{error.first.to_s}"}: #{error[1][0].to_s}"
    end

  end

  on :row_processed do
    @row_count += 1
  end

  on :row_error do |e|
    logger.error e.message
  end

  on :import_failed do |exception|
    logger.error exception.message
  end

  on :import_finished do
    if @bargains_order.order_products.present?
      unless @bargains_order.save
        error = @bargains_order.errors.messages.first
        raise "#{I18n.t "activerecord.attributes.product.#{error.first.to_s}"}: #{error[1][0].to_s}"
      end
    end

    if @normal_order.order_products.present?
      unless @normal_order.save
        error = @normal_order.errors.messages.first
        raise "#{I18n.t "activerecord.attributes.product.#{error.first.to_s}"}: #{error[1][0].to_s}"
      end
    end

    logger.info "#{@row_count} lines Data imported successfully!"
  end

  private

  def logger
    Logger.new "log/product_import.log"
  end
end
