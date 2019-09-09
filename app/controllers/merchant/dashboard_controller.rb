class Merchant::DashboardController < ApplicationController
  before_action :require_merchant


  def index
    @merchant = Merchant.find(current_user.merchant_id)
    #@quantity_for_each_order_id = @merchant.item_orders.group(:order_id).sum(:quantity)
    #@subtotal_for_each_order_id = @merchant.item_orders.group(:order_id).sum("quantity * item_orders.price")
    @order_details = @merchant.item_orders.group(:order_id).select("sum(quantity) as total_quantity, sum(quantity * item_orders.price) as total_subtotal")
    binding.pry
  end

  private
    def require_merchant
      render file: "/public/404" unless current_merchant_admin? || current_merchant_employee?
    end
end
