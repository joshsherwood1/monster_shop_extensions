require 'rails_helper'

describe Address, type: :model do
  describe "validations" do
    it {should validate_presence_of(:address)}
    it {should validate_presence_of(:city)}
    it {should validate_presence_of(:state)}
    it {should validate_presence_of(:zip)}
    it {should validate_numericality_of(:zip)}
    it {should validate_presence_of(:address_type)}
  end

  describe "relationships" do
    it {should belong_to :user}
  end

  describe "instance methods" do
    it "can see if an address has any shipped orders associated with it" do
      @user = User.create!(name: 'Christopher', email: 'christopher123@email.com', password: 'p@ssw0rd', role: 0)
      @address_home = @user.addresses.create!(address: "1600 Pennsylvania Ave NW", city: "Washington", state: "DC", zip: 20500)
      @address_2 = @user.addresses.create(address: "234 Main", city: "Denver", state: "CO", zip: 80204)
      @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      @order_5 = @user.orders.create!(address_id: @address_2.id, status: 2)
      @order_6 = @user.orders.create!(address_id: @address_2.id, status: 2)
      @order_7 = @user.orders.create!(address_id: @address_2.id, status: 1)
      @item_order_2 = @order_5.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 2, merchant_id: @dog_shop.id)
      @item_order_2 = @order_6.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 2, merchant_id: @dog_shop.id)
      @item_order_2 = @order_7.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 2, merchant_id: @dog_shop.id)

      expect(@address_2.shipped_orders_with_address?(@address_2.id)).to eq(true)
      expect(@address_2.shipped_orders_with_address?(@address_home.id)).to eq(false)
    end
  end
end
