class Order < ActiveRecord::Base
  STATUS = [['Pending','Pending'],['In progress','In progress'],['Completed','Completed']]
  belongs_to :user
  has_many :order_items, dependent: :destroy

  validate :delivery_time_cannot_be_earlier_than_present, on: :create

  def completed?
    status == 'Completed' ? true : false
  end

  private
  def delivery_time_cannot_be_earlier_than_present
    if delivery_time.present?
      input_time = delivery_time.change(min: 0)
      current_time = DateTime.current.change(min: 0)
      if input_time < current_time
        errors.add(:delivery_time, I18n.t(:order_delivery_time_error))
        false
      else
        true
      end
    else
      true
    end
  end

end
