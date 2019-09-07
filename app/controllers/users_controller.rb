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
      render :new
      # redirect_to '/register'
    end
  end



  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def password_edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.update(user_params)
    if user_params.include?(:password)
      redirect_to '/profile'
      flash[:success] = 'Your password has been updated'
    elsif @user.save
      redirect_to '/profile'
      flash[:success] = 'Your profile has been updated'
    else
      redirect_to '/profile/edit'
      flash[:error] = @user.errors.full_messages.uniq
    end
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
