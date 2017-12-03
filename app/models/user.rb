class User < ActiveRecord::Base
  enum role_id: { "admin" => 1, "waiter" => 2 }
  before_destroy :has_orders?
  has_many :orders

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  private
  def has_orders?
    return true if orders.empty?
    errors.add(:base, I18n.t(:waiter_delete_orders_error))
    return false
  end
end
