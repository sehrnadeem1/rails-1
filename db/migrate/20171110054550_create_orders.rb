class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :status
      t.string :description
      t.datetime :time
      t.references :user, foreign_key: true, index: true

      t.timestamps null: false
    end
  end
end
