class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
        can :manage, :all
    else
        can :read, :all
        can :manage, Order, { user_id: user.id }
        can :manage, OrderItem
    end
  end
end
