class Merchant::ItemsController < Merchant::BaseController

  def index
    @merchant = Merchant.find(current_user.merchant_id)
  end

  def destroy
   item = Item.find(params[:item_id])
   Review.where(item_id: item.id).destroy_all
   item.destroy
   redirect_to "/merchant/items"
   flash[:success] = "#{item.name} has been deleted"
  end

  def toggle
    item = Item.find(params[:item_id])
    item.toggle
    if item.active? == false
      flash[:deactivate] = "#{item.name} no longer for sale"
    else
      flash[:activate] = "#{item.name} for sale"
    end
    redirect_to "/merchant/items"
  end
end
