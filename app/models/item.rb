class Item < ActiveRecord::Base
	validates :quantity, :numericality => { :greater_than_or_equal_to => 0 }
	validates :price, :numericality => { :greater_than => 0 }
	validates_presence_of :name

	has_many :order_items, dependent: :destroy
end
