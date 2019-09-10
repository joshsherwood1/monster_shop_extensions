class Merchant::ItemordersController < Merchant::BaseController
  def fulfill
    @item_order = ItemOrder.find(params[:id])
    @item_order.fulfill_and_save_item_order
    item = Item.find(@item_order.item_id)
    item.subtract(@item_order.quantity)
    redirect_to "/orders/#{@item_order.order_id}"
    flash[:success] = "#{Item.find(@item_order.item_id).name} is now fulfilled"
  end
end
