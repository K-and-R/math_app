class Ability
  include CanCan::Ability

  def initialize(user)
    @user ||= User.new # guest user (not logged in)
    alias_action :create, :read, :update, :destroy, to: :crud
    default_abilities
    load_admin_abilities if user.admin?
  end

  def default_abilities
    # Allow a user to edit their own profile
    can [:edit, :update], User, id: @user.id
  end

  def load_admin_abilities
    # Admins can do everything
    can :manage, :all if user.admin?
  end
end
