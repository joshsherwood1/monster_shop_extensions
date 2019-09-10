class Merchant::ItemordersController < Merchant::BaseController
  def fulfill
    @item_order = ItemOrder.find(params[:id])
    @item_order.status = "fulfilled"
    @item_order.save
    item = Item.find(@item_order.item_id)
    item.inventory -= @item_order.quantity
    item.save
    redirect_to "/orders/#{@item_order.order_id}"
    flash[:success] = "#{Item.find(@item_order.item_id).name} is now fulfilled"
  end
end
