class CurrentPagesController < ApplicationController
	def home
		#Rails will look at this controller, then automatically render the view
	end 
	def aboutus
	end 
	def ourwork
    end
    def properties 
    end
    def donations
    end
    def accepteddonations
    end 
    def testimonials 
    end 
    def contactus
    	if logged_in?
    		@person_name = @current_user[:name]
    	end
    end 
end
