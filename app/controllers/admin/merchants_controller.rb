class Admin::MerchantsController < Admin::BaseController

  def show
    @merchant = Merchant.find(params[:merchant_id])
  end

  def toggle
    merchant = Merchant.find(params[:merchant_id])
    merchant.toggle
    if merchant.enabled?
      merchant.activate_items
      flash[:enable] = "#{merchant.name} enabled"
    else
      merchant.deactivate_items
      flash[:disable] = "#{merchant.name} disabled"
    end
    redirect_to "/merchants"
  end

end
