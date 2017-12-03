class RenameItemImage < ActiveRecord::Migration
  def change
    rename_column :items, :item_image_file_name, :image_file_name
    rename_column :items, :item_image_content_type, :image_content_type
    rename_column :items, :item_image_file_size, :image_file_size
    rename_column :items, :item_image_updated_at, :image_updated_at
  end
end
