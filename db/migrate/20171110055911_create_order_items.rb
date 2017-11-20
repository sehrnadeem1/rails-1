class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.integer :quantity
      t.references :item, foreign_key: true, index: true
      t.references :order, foreign_key: true, index: true

      t.timestamps null: false
    end
  end
end
