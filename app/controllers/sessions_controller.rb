class SessionsController < ApplicationController
  def new
  end
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    # Gets the user's email and password from the form and compares it with the User db
    if user && user.authenticate(params[:session][:password])
      # Log in and render that user's page
      log_in user # Helper function login! -> Creates a temporary session for the user!
      flash[:success] = "Logged in as " + params[:session][:email].downcase
      redirect_to user
    else
      flash.now[:danger] = "Invalid email/password combination!"
      render 'new' # Does not count as a redirect, so be careful with flash messages
    end
  end
  def destroy
    log_out
    flash[:success] = "Logged out..."
    redirect_to root_url
  end
end
