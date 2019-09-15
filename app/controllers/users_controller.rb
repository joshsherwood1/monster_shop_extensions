class UsersController < ApplicationController
  before_action :require_user, only: [:show]
  before_action :cur_user, only: [:edit, :password_edit, :update]

  def new
    @user = User.new
    @address = @user.addresses.new
  end

  def create
    @user = User.create(user_params)
    #@new_address = Address.create(address_params)
    if @user.save
      @address = @user.addresses.create(address_params)
      if @address.save
        session[:user_id] = @user.id
        flash[:success] = "Welcome, #{@user.name}! You are now registered and logged in."
        redirect_to "/profile"
      end
    else
      flash[:error] = @user.errors.full_messages.uniq.to_sentence
      #flash[:error] = @new_address.errors.full_messages.uniq.to_sentence
      render :new
    end
  end


  def show
    if current_user && current_admin?
      @user = User.find(params[:user_id])
    elsif current_user
      @user = current_user
    end
  end

  def edit
  end

  def password_edit
  end

  def update
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
    params.require(:user).permit(:name, :email, :password, :password_confirmation, address_attributes: [:address, :city, :state, :zip, :address_type])
  end

  def address_params
    params.require(:user).require(:address).permit(:address, :city, :state, :zip, :address_type)
  end

  def cur_user
    @user = current_user
  end
end
