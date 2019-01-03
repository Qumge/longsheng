class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string :action
      t.string :target
      t.string :desc
      t.timestamps null: false
    end
  end
end
