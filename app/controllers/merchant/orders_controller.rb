class Merchant::OrdersController < Merchant::BaseController

  def show
    @merchant = Merchant.find(current_user.merchant_id)
    @order = Order.find(params[:order_id])
    @item_orders = @order.show_order(@merchant.id)
  end

end
