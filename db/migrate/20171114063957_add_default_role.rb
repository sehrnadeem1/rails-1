class AddDefaultRole < ActiveRecord::Migration
  def change
  	change_column_default :users, :role_id, 2
  end
end
