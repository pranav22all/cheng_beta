class UsersController < ApplicationController
  #This applies to the user pages for edit and update, can't see unless logged in
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy 
  def new
  	@user = User.new 
  end
  def index 
    #Index takes in this instance variable, based on the page selects what users to display 
    @users = User.paginate(page: params[:page])
  end
  def show
  	#automatically has an id from the URL (the number after users is the id)
  	@user = User.find(params[:id])
  end
  def create
  	@user=User.new(user_params)
  	if @user.save
      @user.send_activation_email
      flash[:info] = "An activation link has been sent to your email. Please click on it to activate your account."
      redirect_to root_url
  	else
  		render 'new'
  	end
  end
  def edit 
    @user = User.find(params[:id])
  end
  def update
    #user_params is the information the user passes in 
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user 
    else
      render 'edit'
    end
  end
  def destroy 
    User.find(params[:id]).destroy
    flash[:success] = "User has been terminated"
    redirect_to users_url
  end
  private 
  	#This is a method, it's tied with the form on the respective page 
    def user_params
  		params.require(:user).permit(:name,:email,:password,:password_confirmation)
  	end
    #These are to limit access to pages like I wanted
    def logged_in_user 
      unless logged_in? 
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url 
      end
    end
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    def admin_user
      redirect_to(root_url) unless current_user.admin? 
    end
end
