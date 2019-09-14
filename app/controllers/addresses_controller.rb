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

  def address_params
    params.permit(:address_type, :address, :city, :state, :zip)
  end
end
