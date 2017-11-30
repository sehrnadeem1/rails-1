class ChangeColumnNameTime < ActiveRecord::Migration
  def change
  	rename_column :orders, :time, :delivery_time
  end
end
