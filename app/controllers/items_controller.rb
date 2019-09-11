class ItemsController<ApplicationController
  before_action :set_merchant, only: [:new, :create]

  def index
    if params[:merchant_id]
      @merchant = Merchant.find(params[:merchant_id])
      @items = @merchant.items
    else
      @items = Item.all
    end
    @five_least_popular_items = @items.least_popular_items
    @five_most_popular_items = @items.most_popular_items
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
  end

  def create
    item = @merchant.items.create(item_params)
    if item.save
      redirect_to "/merchants/#{@merchant.id}/items"
    else
      flash[:error] = item.errors.full_messages.to_sentence
      render :new
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    redirect_to "/items"
  end

  private

  def item_params
    params.permit(:name,:description,:price,:inventory,:image)
  end

  def set_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end
