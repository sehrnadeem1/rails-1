module OrderItemsHelper
  def calculate_price(order_item)
    number_to_currency(order_item.item.price * order_item.quantity, unit: "Rs ")
  end

  def display_item_name(order_item)
    if order_item.item.active?
      link_to order_item.item.name, order_order_item_path(order_item.order, order_item)
    else
      order_item.item.name + ' (this item is no longer available)'
    end
  end

  def calculate_total_price(order)
    total_price = 0
    order_items = order.order_items
    order_items.each do |order_item|
      total_price += order_item.quantity * order_item.item.price
    end
    total_price
  end
end


