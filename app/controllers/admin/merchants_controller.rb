class Admin::MerchantsController < Admin::BaseController

  def show
    @merchant = Merchant.find(params[:merchant_id])
  end

  def toggle
    merchant = Merchant.find(params[:merchant_id])
    merchant.toggle
    if merchant.enabled?
      flash[:enable] = "#{merchant.name} enabled"
    else
      flash[:disable] = "#{merchant.name} disabled"
    end
    redirect_to "/merchants"
  end

end
