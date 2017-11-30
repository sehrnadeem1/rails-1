class Item < ActiveRecord::Base
  has_attached_file :item_image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/no-image.png"
  validates_attachment_content_type :item_image, content_type: /\Aimage\/.*\z/

  validates :quantity, numericality: { greater_than_or_equal_to: 0, message: I18n.t(:item_quantity_error) }
  validates :price, numericality: { greater_than: 0, message: I18n.t(:item_price_error) }
  validates :name, presence: true, length: { maximum:255 }

  has_many :order_items
end
