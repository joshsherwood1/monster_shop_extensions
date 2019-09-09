class Admin::DashboardController < Admin::BaseController

  def index
    @sorted_orders = Order.sort_orders
  end

end
