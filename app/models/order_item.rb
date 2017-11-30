class OrderItem < ActiveRecord::Base
  belongs_to :item
  belongs_to :order

  validates :quantity, numericality: { greater_than: 0 }
  validates_associated :item
end
