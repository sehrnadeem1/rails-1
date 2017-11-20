class User < ActiveRecord::Base
	enum role_id: {"admin"=>1, "waiter"=>2}

	has_many :orders, dependent: :nullify

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
end
