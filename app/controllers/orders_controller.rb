class OrdersController <ApplicationController

  def new
    @address = Address.find(params[:address_id])
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
    address = Address.find(params[:address_id])
    order.address_id = address.id
    if order.save
      cart.create_item_orders(order)
      session.delete(:cart)
      flash[:success] = "Order Created!"
      redirect_to "/profile/orders"
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  def update
    order = Order.find(params[:order_id])
    address = Address.find(params[:address_id])
    order.address = address
    order.save
    redirect_to "/orders/#{order.id}"
  end


  def cancel
    order = Order.find(params[:order_id])
      order.cancel_order
    redirect_to "/profile"
    flash[:success] = ("Order #{order.id} has been cancelled")
  end

  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end
end
