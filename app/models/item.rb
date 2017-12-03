class Item < ActiveRecord::Base
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/no-image.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :price, numericality: { greater_than: 0 }
  validates :name, presence: true, length: { maximum:255 }

  before_destroy :inclusion_in_orders?
  has_many :order_items

  scope :active, -> { where(active: true) }

  private
  def inclusion_in_orders?
    return true if order_items.empty?
    errors.add(:base, I18n.t(:item_delete_fail))
    return false
  end

end
