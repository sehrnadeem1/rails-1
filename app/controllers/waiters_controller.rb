class WaitersController < ApplicationController

  #GET /waiters
  def index
    if current_user.admin?
      @waiters = User.waiter
       respond_to do |format|
        format.html
      end
    end
  end

end
