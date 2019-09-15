require 'rails_helper'

describe ItemOrder, type: :model do
  describe "validations" do
    it { should validate_presence_of :order_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :price }
    it { should validate_presence_of :quantity }
  end

  describe "relationships" do
    it {should belong_to :item}
    it {should belong_to :order}
    it {should have_one :merchant}
  end

  describe 'instance methods' do
    it 'subtotal' do

      @user = User.create!(name: 'Christopher', email: 'christopher123@email.com', password: 'p@ssw0rd', role: 0)
      address_home = @user.addresses.create!(address: "1600 Pennsylvania Ave NW", city: "Washington", state: "DC", zip: 20500)
      @meg = Merchant.create(name: "Meg's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      tire = @meg.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      order_1 = @user.orders.create!(address_id: address_home.id, status: 2)
      item_order_1 = order_1.item_orders.create!(item_id: tire.id, price: tire.price, quantity: 2, merchant_id: @meg.id)

      expect(item_order_1.subtotal).to eq(42.0)
    end

    it 'fulfill_and_save_item_order' do
      @user = User.create!(name: 'Christopher', email: 'christopher123@email.com', password: 'p@ssw0rd', role: 0)
      address_home = @user.addresses.create!(address: "1600 Pennsylvania Ave NW", city: "Washington", state: "DC", zip: 20500)
      @meg = Merchant.create!(name: "Meg's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      tire = @meg.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      order_1 = @user.orders.create!(address_id: address_home.id, status: 2)
      item_order_2 = order_1.item_orders.create!(item_id: tire.id, price: tire.price, quantity: 2, merchant_id: @meg.id)

      expect(item_order_2.status).to eq("unfulfilled")
      item_order_2.fulfill_and_save_item_order
      expect(item_order_2.status).to eq("fulfilled")
    end
  end

end
