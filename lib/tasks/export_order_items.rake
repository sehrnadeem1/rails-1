namespace :export do
task :show_item_used, [:item_name] => :environment do |t, args|
    require 'csv'
    CSV.open("items_consumed.csv", "w") do |csv|
      csv << ['Order ID', 'Order item ID', 'Item quantity']
      @orders =  Order.all
      @orders.each do |order|
        @order_items = order.order_items
        @order_items.each do |order_item|
          csv << [order.id, order_item.id, order_item.quantity] if order_item.item.name == args[:item_name]
        end
      end
    end

  end

end
