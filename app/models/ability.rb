# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, :all
    else
      can :read, List
      can :manage, Card
      can :manage, Comment
    end
  end
end
