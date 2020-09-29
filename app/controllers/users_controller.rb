class UsersController < ApplicationController
  def new
    # Creates a new User to pass into form-for
    @user = User.new
  end
  def show
    # Shows a single user! (/users/[id])
    @user = User.find(params[:id])
  end

  # POST request to /users

  def create
    @user = User.new(user_params) 
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the sample app!"
      redirect_to @user
    else
      render 'new'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
