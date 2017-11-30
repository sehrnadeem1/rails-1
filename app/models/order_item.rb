class OrderItem < ActiveRecord::Base
  belongs_to :item
  belongs_to :order

  validates :quantity, numericality: { greater_than: 0 }
  validates_associated :item

  def check_updated_quantity(new_item_id, new_quantity)
    if item.id == new_item_id
      if new_quantity > quantity
        quantity_diff = item.quantity - (new_quantity - quantity)
      else
        quantity_diff = item.quantity + (quantity - new_quantity)
      end
      item.update(quantity: quantity_diff)
    else
      new_item = Item.find_by(id: new_item_id)
      if new_item.present? && new_item.update(quantity: new_item.quantity - new_quantity)
        item.update(quantity: item.quantity + quantity)
      else
        false
      end
    end
  end

end
