class Merchant::ItemsController < Merchant::BaseController
  def index
    @merchant = Merchant.find(current_user.merchant_id)
  end

  def new
    @merchant = Merchant.find(current_user.merchant_id)
    @item = Item.new
  end
  

  def edit
    @merchant = Merchant.find(current_user.merchant_id)
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    @item.update(item_params)
    if @item.save
      redirect_to '/merchant/items'
      flash[:success] = "#{@item.name} has been updated"
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    item = Item.find(params[:id])
    Review.where(item_id: item.id).destroy_all
    item.destroy
    redirect_to '/merchant/items'
    flash[:success] = "#{item.name} has been deleted"
  end

  def toggle
    @item = Item.find(params[:item_id])
    @item.toggle
    if @item.active? == false
      flash[:deactivate] = "#{@item.name} no longer for sale"
    else
      flash[:activate] = "#{@item.name} for sale"
    end
    redirect_to '/merchant/items'
  end

  def create
    @merchant = Merchant.find(current_user.merchant_id)
    @item = @merchant.items.create(item_params)
    if @item.save
      redirect_to "/merchant/items"
      flash[:success] = "#{@item.name} has been created"
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :price, :inventory, :image)
  end
end
