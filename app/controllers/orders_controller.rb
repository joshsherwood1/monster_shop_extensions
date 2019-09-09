class OrdersController <ApplicationController

  def new

  end

  def show
    @order = Order.find(params[:order_id])
    @user = current_user
  end

  def index
    @user = current_user
  end

  def create
    user = User.find(session[:user_id])
    order = user.orders.create(order_params)
    if order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      order.item_orders.each do |item_order|
        item = Item.find(item_order.item_id)
        # binding.pry
        #This method should probably be moved to model
        item.inventory -= item_order.quantity
        item.save
      end
      session.delete(:cart)
      flash[:success] = "Order Created!"
      redirect_to "/profile/orders"
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end


  def cancel
    order = Order.find(params[:order_id])
      order.item_orders.each do |item_order|
        item_order[:status] = "unfulfilled"
        item = Item.find(item_order.item_id)
        #This method should probably be moved to model
        # item.inventory += item_order.quantity
        item.add(item_order.quantity)
        item.save
      end
    order.update(status: 3)
    redirect_to "/profile"
    flash[:success] = ("Order #{order.id} has been cancelled")
  end

  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end
end
