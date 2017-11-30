class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
      can :manage, Item, { active: true }
      can :manage, Order
      can :manage, OrderItem
    else
      can :read, Item, { active: true }
      can :manage, Order, { user_id: user.id }
      can :manage, OrderItem
    end
  end
end
