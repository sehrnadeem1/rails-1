class OrderItem < ActiveRecord::Base
  belongs_to :item
  belongs_to :order

  validates :quantity, :numericality => { :greater_than_or_equal_to => 0 }
end
