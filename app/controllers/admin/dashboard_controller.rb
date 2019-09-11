class Admin::DashboardController < Admin::BaseController

  def index
    @sorted_orders = Order.sort_orders
  end

  def ship
    order = Order.find(params[:order_id])
    order.shipped
    redirect_to "/admin"
  end

end
