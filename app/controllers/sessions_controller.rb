class SessionsController < ApplicationController

    def new
      render 'users/login'
    end

    def create
      # user = User.find_by(name: params[:name])
<<<<<<< HEAD
      # if user && user.authenticate(params[:password])
      #   session[:user_id] = user.id
      #   flash[:success] = "Login in successful!"
=======
      # flash[:success] = "Login in successful!"
      # if user && user.authenticate(params[:password])
      #   session[:user_id] = user.id
>>>>>>> f8fa27736c58ca5fa3e6e43164fde5f8ef74d3b3
      #   redirect_to '/'
      # else
      #   render 'users/login'
      # end
    end
end
