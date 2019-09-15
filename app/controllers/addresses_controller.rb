class AddressesController < ApplicationController
  def new
    @address = Address.new
  end

  def create
    user = current_user
    address = user.addresses.create(address_params)
    if address.save
      redirect_to "/profile"
    else
      flash[:error] = address.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @address = Address.find(params[:address_id])
  end

  def update
    @address = Address.find(params[:address_id])
    @address.update(address_params)
    if @address.save
      redirect_to "/profile"
    else
      flash[:error] = @address.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    Address.destroy(params[:address_id])
    redirect_to '/profile'
  end

  def address_params
    params.permit(:address_type, :address, :city, :state, :zip)
  end
end
