class SessionsController < ApplicationController

    def new
      render 'users/login'
    end

    def create
      user = User.find_by(email: params[:email])
      flash[:success] = "Login in successful!"
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to '/'
      else
        render 'users/login'
      end
    end

    private

    def session_params
      
    end
end
