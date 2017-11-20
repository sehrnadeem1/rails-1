class WaitersController < ApplicationController
	before_action :authenticate_user!

	def index										#GET    /waiters
		if current_user.admin?
			@waiters = User.waiter

			 respond_to do |format|
		    format.html
		    format.xml { render xml: @waiters }
		  end
		end
	end

end
