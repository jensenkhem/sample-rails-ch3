class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def new
    # Creates a new User to pass into form-for
    @user = User.new
  end

  def index
    @users = User.where(activated: true).paginate(page: params[:page]) 
  end

  def show
    # Shows a single user! (/users/[id])
    @user = User.find(params[:id])
    # If the user is not activated, do not allow visiting the profile!
    redirect_to root_url and return unless @user.activated
  end

  # POST request to /users

  def create
    @user = User.new(user_params) 
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account!"
      redirect_to root_url
      # log_in @user
      # flash[:success] = "Welcome to the sample app!"
      # redirect_to @user
    else
      render 'new'
    end
  end

  # Gets the current user for the form-for update -> /users/[id]/edit
  def edit
    @user = User.find(params[:id])
  end

  # PUT/PATCH request for the user
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated successfully"
      redirect_to @user
    else
      render 'edit'
    end
  end

  # DESTROY request for a user
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # Before

    # Confirms a logged in user!
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end 

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless @user == current_user
    end

    def admin_user
      redirect_to root_url unless current_user.admin?
    end
end
