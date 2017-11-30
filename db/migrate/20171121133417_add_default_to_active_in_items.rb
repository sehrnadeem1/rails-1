class AddDefaultToActiveInItems < ActiveRecord::Migration
  def change
    change_column_default :items, :active, 1
  end
end
