class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
  end

  def create
    user = User.create(user_params)
    session[:user_id] = user.id
    if user.save
      flash[:success] = "Welcome, #{user.name}!"
      redirect_to "/profile"
    else
      flash[:error] = user.errors.full_messages
      redirect_to '/register'
    end
  end



  def show
  end

  private

  def require_user
    render file: "/public/404" unless current_user
  end

  #Need to make sure that user_params doesn't store password
  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password)
  end
end
