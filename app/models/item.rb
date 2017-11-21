class Item < ActiveRecord::Base
  validates :quantity, :numericality => { greater_than_or_equal_to: 0 }
  validates :price, :numericality => { greater_than: 0 }
  validates :name, presence: true, length: { maximum: 255 }

  has_many :order_items, dependent: :destroy
end
