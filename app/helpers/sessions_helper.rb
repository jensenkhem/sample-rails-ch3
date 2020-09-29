module SessionsHelper
    # Logs in the given user
    def log_in (user)
        session[:user_id] = user.id
    end   

    def log_out
        session.delete(:user_id)
        @current_user = nil
    end

    # Returns the current logged-in user, nil otherwise
    def current_user
        if session[:user_id]
            # Set @current_user its current value if it exists, or find it by session id
            # This way of assignment avoid over-accessing the db
            @current_user = @current_user || User.find_by(id: session[:user_id])
        end
    end

    # Check if the user is logged into a session!
    # Calls the above current_user function to avoid accessing the db
    def logged_in?
        return !current_user.nil?
    end

end
