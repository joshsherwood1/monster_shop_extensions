class UsersController < ApplicationController

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
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.update(user_params)
    redirect_to '/profile'
    flash[:success] = 'Your profile has been updated'
  end

  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password)
  end
end
