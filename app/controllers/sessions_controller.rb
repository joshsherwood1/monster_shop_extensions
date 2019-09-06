class SessionsController < ApplicationController

    def new
      render 'users/login'
    end

    def create
      user = User.find_by(email: params[:email])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        flash[:success] = "Login in successful!"
        if current_merchant_employee? || current_merchant_admin?
          redirect_to '/merchant'
        elsif current_admin?
          redirect_to '/admin'
        else
          redirect_to '/profile'
        end
      else
        flash[:error] = "Login information incorrect"
        redirect_to '/login'
      end
    end
end
