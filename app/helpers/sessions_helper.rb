module SessionsHelper
    # Logs in the given user
    def log_in (user)
        session[:user_id] = user.id
    end   

    def log_out
        forget_user(current_user) # Must forget the user first, before deleting the session!
        session.delete(:user_id)
        @current_user = nil
    end

    # Returns the current logged-in user, nil otherwise
    def current_user
        if session[:user_id]
            # Set @current_user its current value if it exists, or find it by session id
            # This way of assignment avoid over-accessing the db
            @current_user = @current_user || User.find_by(id: session[:user_id])
        elsif (user_id = cookies.signed[:user_id])
            # If there is no current session, use the cookie instead!
            # The elsif condition above checks to see if the cookie exists in the client
            # and assigns it to user_id, which is used to find the user in the DB
            # Then, we use this user to compare the remember token on the client with the hashed
            # database token, to authenticate the user!
            user = User.find_by(id: user_id)
            if user && user.authenticated?(cookies[:remember_token])
                log_in user
                @current_user = user
            end 
        end
    end

    def current_user?(user)
        return user == current_user
    end


    # Uses cookies to remember the user for the next time they visit the site
    def remember_user(user)
        user.remember
        cookies.permanent.signed[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end

    def forget_user(user)
        user.forget
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
    end

    # Check if the user is logged into a session!
    # Calls the above current_user function to avoid accessing the db
    def logged_in?
        return !current_user.nil?
    end

    # Redirects to stored location (or to the default). 
    def redirect_back_or(default)
        redirect_to(session[:forwarding_url] || default)
        session.delete(:forwarding_url) 
    end

    # Stores the URL trying to be accessed.
    def store_location
        session[:forwarding_url] = request.original_url if request.get?
    end

end
