class SessionsController < ApplicationController

    def new
      render 'users/login'
    end

    def create
<<<<<<< HEAD
      user = User.find_by(email: params[:email])
      flash[:success] = "Login in successful!"
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to '/'
      else
        render 'users/login'
      end
=======
      # user = User.find_by(name: params[:name])
      # flash[:success] = "Login in successful!"
      # if user && user.authenticate(params[:password])
      #   session[:user_id] = user.id
      #   redirect_to '/'
      # else
      #   render 'users/login'
      # end
>>>>>>> 7a330f30a2e4a6f9dc9590e29fc928971882e047
    end

    private

    def session_params
      
    end
end
