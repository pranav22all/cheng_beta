class SessionsController < ApplicationController
  #Just having the basic RESTful Actions in here
  def new
  end
  def create
  	#Finds the user using the default params hash entered
  	user = User.find_by(email:params[:session][:email].downcase)
  	#if user == true (email in database) and password authenticated
  	if user && user.authenticate(params[:session][:password])
    	if user.activated? 	
        #Log user in and redirect to user's "show" page 
    		#Uses our helper method to log in + place temp cookie 
    		log_in user 
        #Based on whether user checks the checkbox, correspond accourdingly
        if params[:session][:remember_me] == '1'
        #Calling a method in session helper that generates a user cookie token and hash (digest)        
          remember(user)
        else
          forget(user)
        end 
        #user page is taken as the default parameter for this method
    		redirect_back_or user
      else
        message = "Account has not been activated. "
        message = message + "Please check your email for the activation link."
        flash[:warning]=message
        redirect_to root_url
      end
    else 	
  	#Just render new view for now + Create error message 
  	#our application.html.erb has a method for dealing with flashes
  		flash.now[:danger] = 'Invalid email and password combination'
  		render 'new' #Basically runs the new controller / view
  	end
  end
  def destroy
  	log_out if logged_in? #the if logged_in? is in case in multiple windows
  	redirect_to root_url
  end
end
