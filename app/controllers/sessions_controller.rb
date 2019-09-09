class SessionsController < ApplicationController

    def new
      if current_user
        flash[:error] = "Already logged in"
        redirect_by_user_type
      else
        render '/users/login'
      end
    end

    def create
      user = User.find_by(email: params[:email])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        flash[:success] = "Login in successful!"
        redirect_by_user_type
      else
        flash[:error] = "Login information incorrect"
        redirect_to '/login'
      end
    end

    def destroy
      session.delete(:cart)
      session.delete(:user_id)
      #reset_session
      #session[:user_id] = nil

      flash[:success] = "You have been logged out."
      redirect_to '/'
    end
    private

    def redirect_by_user_type
      if current_merchant_employee? || current_merchant_admin?
        redirect_to '/merchant'
      elsif current_admin?
        redirect_to '/admin'
      else
        redirect_to '/profile'
      end
    end
  end
