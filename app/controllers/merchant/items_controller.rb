class Merchant::ItemsController < Merchant::BaseController
  before_action :set_item, only: [:edit, :update, :destroy]
  def index
    @merchant = Merchant.find(current_user.merchant_id)
  end

  def new
    if current_merchant_admin?
      @merchant = Merchant.find(current_user.merchant_id)
      @item = Item.new
    end
  end

  def edit
    @merchant = Merchant.find(current_user.merchant_id)
  end

  def update
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
    @item.destroy
    redirect_to '/merchant/items'
    flash[:success] = "#{@item.name} has been deleted"
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
    if @item.image == ""
     @item.show_default_image
    end
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

  def set_item
    @item = Item.find(params[:id])
  end
end
