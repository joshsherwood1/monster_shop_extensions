class Merchant::DashboardController < Merchant::BaseController

  def index
    @merchant = Merchant.find(current_user.merchant_id)
    #@quantity_for_each_order_id = @merchant.item_orders.group(:order_id).sum(:quantity)
    #@subtotal_for_each_order_id = @merchant.item_orders.group(:order_id).sum("quantity * item_orders.price")
    @order_details = @merchant.item_orders.group(:order_id).select("sum(quantity) as total_quantity, sum(quantity * item_orders.price) as total_subtotal")
    binding.pry
  end

end
