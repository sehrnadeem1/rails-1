namespace :export do
task show_item_used: :environment do
    require 'csv'
    CSV.open("public/items_consumed.csv", "w") do |csv|
      csv << ['Order ID', 'Order item ID', 'Item quantity', 'Item Price']

      puts 'Enter item name: '
      item_name = STDIN.gets.strip
      abort "Item not found." if Item.find_by(name: item_name).blank?

      OrderItem.joins(:item).where(items: {name: item_name}).each do |order_item|
        csv << [order_item.order_id, order_item.id, order_item.quantity, order_item.item.price]
      end

    end

  end

end
