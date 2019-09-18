class Merchant::CouponsController < Merchant::BaseController

  def index
    @merchant = Merchant.find(current_user.merchant_id)
  end

  def new
  end

  def create
    merchant = Merchant.find(current_user.merchant_id)
    coupon = merchant.coupons.create(coupon_params)
    if ((coupon_params[:amount_off] == "") == false) && ((coupon_params[:percent_off] == "") == false)
      flash[:error] = "Please choose only a percent off or amount off"
      render :new
      coupon.destroy
    elsif coupon.save
      redirect_to "/merchant/coupons"
    else
      flash[:error] = coupon.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @coupon = Coupon.find(params[:id])
  end

  def update
    @coupon = Coupon.find(params[:id])
    @coupon.update(coupon_params)
  #  binding.pry
    if ((coupon_params[:amount_off] == "") == false) && ((coupon_params[:percent_off] == "") == false)
      flash[:error] = "Please choose only a percent off or amount off"
      render :edit
    elsif @coupon.save
      redirect_to "/merchant/coupons"
    else
      flash[:error] = @coupon.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    Coupon.destroy(params[:id])
    redirect_to "/merchant/coupons"
  end

  def toggle_coupon
    @coupon = Coupon.find(params[:id])
    @coupon.toggle_off
    redirect_to "/merchant/coupons"
  end

  private

  def coupon_params
    params.permit(:name, :amount_off, :percent_off)
  end
end
