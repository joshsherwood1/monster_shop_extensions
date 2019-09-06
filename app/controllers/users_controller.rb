class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome, #{@user.name}!"
      redirect_to "/profile"
    else
      flash[:error] = @user.errors.full_messages.uniq
      #this might need to be changed after user can login
      #consider using render
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
