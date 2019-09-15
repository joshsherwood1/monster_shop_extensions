require 'rails_helper'

describe "When regular user creates an order" do
  before :each do
    @regular_user = User.create!(  name: "alec", email: "5@gmail.com", password: "password")
    @address_3 = @regular_user.addresses.create(address: "234 Main", city: "Denver", state: "CO", zip: 80204)
    @address_4 = @regular_user.addresses.create(address: "9990 Palm Drive", city: "Key Largo", state: "FL", zip: 32578, address_type: "Work")
    @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @mike.items.create!(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @mike.items.create!(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    visit "/items/#{@paper.id}"
    click_on "Add To Cart"
    visit "/items/#{@tire.id}"
    click_on "Add To Cart"
    visit "/items/#{@pencil.id}"
    click_on "Add To Cart"
  end
  it "they can see shipping information and order information" do
    visit '/login'
    fill_in :email, with: @regular_user.email
    fill_in :password, with: @regular_user.password
    click_button "Log In"

    visit cart_path
    expect(page).to have_link("#{@address_3.address_type} Address: #{@address_3.address} #{@address_3.city}, #{@address_3.state} #{@address_3.zip}")
    expect(page).to have_link("#{@address_4.address_type} Address: #{@address_4.address} #{@address_4.city}, #{@address_4.state} #{@address_4.zip}")
    click_link ("#{@address_4.address_type} Address: #{@address_4.address} #{@address_4.city}, #{@address_4.state} #{@address_4.zip}")
    expect(current_path).to eq("/orders/new/address/#{@address_4.id}")
    expect(page).to have_content(@address_4.address)
    expect(page).to have_content(@address_4.city)
    expect(page).to have_content(@address_4.state)
    expect(page).to have_content(@address_4.zip)
    expect(page).to have_content(@regular_user.name)
    click_button "Create Order"
    expect(current_path).to eq("/profile/orders")

    order = Order.last
    item = order.items.last
    item_order = order.item_orders.last
    click_link("Order ID: #{order.id}")
    expect(current_path).to eq("/profile/orders/#{order.id}")
    expect(page).to have_content("Date created: #{order.created_at.strftime("%d %b %y")}")
    expect(page).to have_content("Last update: #{order.updated_at.strftime("%d %b %y")}")
    expect(page).to have_content("Order status: #{order.status}")
    expect(page).to have_content("Total items: #{order.total_quantity}")
    expect(page).to have_content("Grand total: $#{order.grandtotal}")
    expect(page).to have_link("Order ID: #{order.id}")

    within "#item-#{item.id}" do
      expect(page).to have_content(item.name)
      expect(page).to have_content(item.description)
      expect(page).to have_css("img[src*='#{item.image}']")
      expect(page).to have_content(item_order.quantity)
      expect(page).to have_content(item.price)
      expect(page).to have_content(item_order.subtotal)
    end

    within ".shipping-address" do
      expect(page).to have_content(@address_4.address)
      expect(page).to have_content(@address_4.city)
      expect(page).to have_content(@address_4.state)
      expect(page).to have_content(@address_4.zip)
      expect(page).to have_content(@regular_user.name)
    end
  end

  it "they can changing the shipping address of a pending order" do
    @regular_user_2 = User.create!(  name: "alec", email: "5655@gmail.com", password: "password")
    @address_6 = @regular_user_2.addresses.create!(address: "234 Main", city: "Denver", state: "CO", zip: 80204)
    @address_7 = @regular_user_2.addresses.create!(address: "987 Evergreen Dr", city: "Seattle", state: "WA", zip: 74132, address_type: "Work")
    @order_1 = @regular_user_2.orders.create!(address_id: @address_6.id)
    ItemOrder.create!(merchant_id: @meg.id, item_id: @tire.id, price: 100, quantity: 1, order_id: @order_1.id)

    visit '/login'
    fill_in :email, with: @regular_user_2.email
    fill_in :password, with: @regular_user_2.password
    click_button "Log In"

    visit "orders/#{@order_1.id}"
    within ".shipping-address" do
      expect(page).to have_content(@address_6.address)
      expect(page).to have_content(@address_6.city)
      expect(page).to have_content(@address_6.state)
      expect(page).to have_content(@address_6.zip)
      expect(page).to have_content(@regular_user.name)
    end

    within ".shipping-address" do
      expect(page).to have_content("Change address to #{@address_7.address_type} Address: #{@address_7.address} #{@address_7.city}, #{@address_7.state} #{@address_7.zip}")
      expect(page).to have_link("#{@address_7.address_type} Address: #{@address_7.address} #{@address_7.city}, #{@address_7.state} #{@address_7.zip}")
      click_link("#{@address_7.address_type} Address: #{@address_7.address} #{@address_7.city}, #{@address_7.state} #{@address_7.zip}")
    end
    expect(current_path).to eq("/orders/#{@order_1.id}")

    within ".shipping-address" do
      expect(page).to have_content(@address_7.address)
      expect(page).to have_content(@address_7.city)
      expect(page).to have_content(@address_7.state)
      expect(page).to have_content(@address_7.zip)
      expect(page).to have_content(@regular_user.name)
      expect(page).to have_content("Change address to #{@address_6.address_type} Address: #{@address_6.address} #{@address_6.city}, #{@address_6.state} #{@address_6.zip}")
    end
  end

  it "they cannot changing the shipping address of an order that is not pending" do
    @regular_user_3 = User.create!(  name: "alec", email: "5655@gmail.com", password: "password")
    @address_7 = @regular_user_3.addresses.create!(address: "234 Main", city: "Denver", state: "CO", zip: 80204)
    @address_8 = @regular_user_3.addresses.create!(address: "987 Evergreen Dr", city: "Seattle", state: "WA", zip: 74132, address_type: "Work")
    @order_2 = @regular_user_3.orders.create!(address_id: @address_7.id, status: 1)
    ItemOrder.create!(merchant_id: @meg.id, item_id: @tire.id, price: 100, quantity: 1, order_id: @order_2.id)

    visit '/login'
    fill_in :email, with: @regular_user_3.email
    fill_in :password, with: @regular_user_3.password
    click_button "Log In"

    visit "orders/#{@order_2.id}"
    within ".shipping-address" do
      expect(page).to have_content(@address_7.address)
      expect(page).to have_content(@address_7.city)
      expect(page).to have_content(@address_7.state)
      expect(page).to have_content(@address_7.zip)
      expect(page).to have_content(@regular_user.name)
    end

    within ".shipping-address" do
      expect(page).to_not have_content("Change address to #{@address_8.address_type} Address: #{@address_8.address} #{@address_8.city}, #{@address_8.state} #{@address_8.zip}")
      expect(page).to_not have_link("#{@address_8.address_type} Address: #{@address_8.address} #{@address_8.city}, #{@address_8.state} #{@address_8.zip}")
    end
  end
end
