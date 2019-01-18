class CreateOrderProducts < ActiveRecord::Migration
  def change
    create_table :order_products do |t|

      t.timestamps null: false
    end
  end
end
