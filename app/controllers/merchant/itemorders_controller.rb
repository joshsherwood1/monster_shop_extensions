class Merchant::ItemordersController < Merchant::BaseController
  def fulfill
    @item_order = ItemOrder.find(params[:id])
    @item_order.fulfill_and_save_item_order
    item = Item.find(@item_order.item_id)
    item.subtract(@item_order.quantity)
    order = Order.find(@item_order.order_id)
    if order.all_item_orders_fulfilled?
      order.packaged
    end
    redirect_to "/merchant/orders/#{@item_order.order_id}"
    flash[:success] = "#{Item.find(@item_order.item_id).name} is now fulfilled"
  end
end
