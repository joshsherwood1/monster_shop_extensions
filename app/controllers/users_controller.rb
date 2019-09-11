class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome, #{@user.name}! You are now registered and logged in."
      redirect_to "/profile"
    else
      flash[:error] = @user.errors.full_messages.uniq
      render :new
    end
  end


  def show
    if current_user && current_admin?
      @user = User.find(params[:user_id])
    elsif current_user
      @user = current_user
    end
    @user
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

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation)
  end
end
