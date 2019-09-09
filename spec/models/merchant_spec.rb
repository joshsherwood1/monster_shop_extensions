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
        address: "234 Main",
        city: "Denver",
        state: "CO",
        zip: 80204,
        email: "alec@gmail.com",
        password: "password"
      )
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    end
    it 'no_orders' do
      expect(@meg.no_orders?).to eq(true)

      order_1 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      item_order_1 = order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

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
      order_2 = @user.orders.create!(name: 'Brian', address: '123 Brian Ave', city: 'Denver', state: 'CO', zip: 17033)
      order_1 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order_3 = @user.orders.create!(name: 'Dao', address: '123 Mike Ave', city: 'Denver', state: 'CO', zip: 17033)
      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      order_2.item_orders.create!(item: chain, price: chain.price, quantity: 2)
      order_3.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.distinct_cities).to eq(["Denver","Hershey"])
    end

    it 'get_individual_orders' do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 11234)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @bike_shop.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @bike_shop.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

      regular_user =  User.create!(  name: "alec",
                      address: "234 Main",
                      city: "Denver",
                      state: "CO",
                      zip: 80204,
                      email: "5@gmail.com",
                      password: "password"
                    )
      @order_1 = regular_user.orders.create!(name: "Sam Jackson", address: "223 Main St", city: "Seattle", state: "Washington", zip: 99987, status: 0)
      @order_2 = regular_user.orders.create!(name: "Sam Jackson", address: "223 Main St", city: "Seattle", state: "Washington", zip: 99987, status: 0)
      item_order_1 = @order_1.item_orders.create!(item_id: @tire.id, quantity: 2, price: 100)
      item_order_2 = @order_1.item_orders.create!(item_id: @paper.id, quantity: 2, price: 20)
      item_order_3 = @order_1.item_orders.create!(item_id: @pencil.id, quantity: 3, price: 2)
      item_order_4 = @order_2.item_orders.create!(item_id: @tire.id, quantity: 1, price: 100)
      item_order_5 = @order_2.item_orders.create!(item_id: @pencil.id, quantity: 4, price: 2)
      actual_total_quantity_for_meg = @meg.get_individual_orders.map {|itemorder| itemorder.total_quantity}.sort
      actual_subtotal_for_meg = @meg.get_individual_orders.map {|itemorder| itemorder.total_subtotal}.sort
      actual_total_quantity_for_bike_shop = @bike_shop.get_individual_orders.map {|itemorder| itemorder.total_quantity}.sort
      actual_subtotal_for_bike_shop = @bike_shop.get_individual_orders.map {|itemorder| itemorder.total_subtotal}.sort
      expect(actual_total_quantity_for_meg).to eq([1, 2])
      expect(actual_subtotal_for_meg).to eq([100.0, 200.0])
      expect(actual_total_quantity_for_bike_shop).to eq([4, 5])
      expect(actual_subtotal_for_bike_shop).to eq([8.0, 46.0])
    end
  end
end
