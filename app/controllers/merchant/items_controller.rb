class Merchant::ItemsController < Merchant::BaseController

  def index
    @merchant = Merchant.find(current_user.merchant_id)
  end

  def toggle
    #add merchant_admin? check
    item = Item.find(params[:item_id])
    # binding.pry
    item.toggle
    if item.active? == false
      flash[:deactivate] = "#{item.name} no longer for sale"
    else
      flash[:activate] = "#{item.name} for sale"
    end
    redirect_to "/merchant/items"
  end
end
