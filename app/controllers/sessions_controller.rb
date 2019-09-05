class SessionsController < ApplicationController

    def new
      render 'users/login'
    end

    def create
      # user = User.find_by(name: params[:name])
      # if user && user.authenticate(params[:password])
      #   session[:user_id] = user.id
      #   flash[:success] = "Login in successful!"
      #   redirect_to '/'
      # else
      #   render 'users/login'
      # end
    end
end
