require 'rails_helper'

describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it {should have_many :items}
  end

  describe 'instance methods' do
    before(:each) do
      @user = User.create!(  name: "alec",
        email: "alec@gmail.com",
        password: "password"
      )
      @address_home = @user.addresses.create!(address: "1600 Pennsylvania Ave NW", city: "Washington", state: "DC", zip: 20500)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @regular_user =  User.create!(  name: "alec", email: "10@gmail.com", password: "password")
      @address_home_2 = @regular_user.addresses.create!(address: "1600 Pennsylvania Ave NW", city: "Washington", state: "DC", zip: 20500)
      @address_home_3 = @user.addresses.create!(address: "1 Main St", city: "Boston", state: "MA", zip: 28500)
      @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210, enabled?: true)
      @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21)

    end
    it 'no_orders' do
      expect(@meg.no_orders?).to eq(true)

      order_1 = @user.orders.create!(address_id: @address_home_3.id)
      item_order_1 = order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, merchant_id: @meg.id)

      expect(@meg.no_orders?).to eq(false)
    end

    it 'item_count' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 30, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)

      expect(@meg.item_count).to eq(2)
    end

    it 'average_item_price' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)

      expect(@meg.average_item_price).to eq(70)
    end

    it 'distinct_cities' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)
      order_2 = @user.orders.create!(address_id: @address_home.id)
      order_1 = @user.orders.create!(address_id: @address_home.id)
      order_3 = @user.orders.create!(address_id: @address_home_3.id)
      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      order_2.item_orders.create!(item: chain, price: chain.price, quantity: 2)
      order_3.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.distinct_cities.sort).to eq(["Boston", "Washington"])
    end

    it 'get_individual_orders' do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 11234)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @bike_shop.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @bike_shop.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

      regular_user =  User.create!(  name: "alec",
                      email: "5@gmail.com",
                      password: "password"
                    )
      @address = regular_user.addresses.create!(address: "1600 Pennsylvania Ave NW", city: "Washington", state: "DC", zip: 20500)

      @order_1 = regular_user.orders.create!(address_id: @address.id)
      @order_2 = regular_user.orders.create!(address_id: @address.id)
      item_order_1 = @order_1.item_orders.create!(item_id: @tire.id, quantity: 2, price: 100, merchant_id: @meg.id)
      item_order_2 = @order_1.item_orders.create!(item_id: @paper.id, quantity: 2, price: 20, merchant_id: @bike_shop.id)
      item_order_3 = @order_1.item_orders.create!(item_id: @pencil.id, quantity: 3, price: 2, merchant_id: @bike_shop.id)
      item_order_4 = @order_2.item_orders.create!(item_id: @tire.id, quantity: 1, price: 100, merchant_id: @meg.id)
      item_order_5 = @order_2.item_orders.create!(item_id: @pencil.id, quantity: 4, price: 2, merchant_id: @bike_shop.id)
      actual_total_quantity_for_meg = @meg.get_individual_orders.map {|itemorder| itemorder.total_quantity}.sort
      actual_subtotal_for_meg = @meg.get_individual_orders.map {|itemorder| itemorder.total_subtotal}.sort
      actual_total_quantity_for_bike_shop = @bike_shop.get_individual_orders.map {|itemorder| itemorder.total_quantity}.sort
      actual_subtotal_for_bike_shop = @bike_shop.get_individual_orders.map {|itemorder| itemorder.total_subtotal}.sort
      expect(actual_total_quantity_for_meg).to eq([1, 2])
      expect(actual_subtotal_for_meg).to eq([100.0, 200.0])
      expect(actual_total_quantity_for_bike_shop).to eq([4, 5])
      expect(actual_subtotal_for_bike_shop).to eq([8.0, 46.0])
    end

    it "toggle" do
      @dog_shop.toggle
      expect(@dog_shop.enabled?).to eq(false)
      @dog_shop.toggle
      expect(@dog_shop.enabled?).to eq(true)
    end

    it "activate_items, deactivate_items" do
      @dog_shop.deactivate_items
      expect(@pull_toy.active?).to eq(false)
      expect(@dog_bone.active?).to eq(false)
      @dog_shop.activate_items
      expect(@pull_toy.active?).to eq(true)
      expect(@dog_bone.active?).to eq(true)
    end
  end
end
