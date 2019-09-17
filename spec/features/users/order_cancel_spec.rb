require 'rails_helper'

describe "when regular user visits cart" do
  before :each do
    @regular_user = User.create!(  name: "alec",
      email: "5@gmail.com",
      password: "password"
    )
    @address_1 = @regular_user.addresses.create!(address: "1600 Pennsylvania Ave NW", city: "Washington", state: "DC", zip: 20500)

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
    visit "/items/#{@pencil.id}"
    click_on "Add To Cart"
    visit '/login'
    fill_in :email, with: @regular_user.email
    fill_in :password, with: @regular_user.password
    click_button "Log In"
  end

  it "I can cancel my orders if status is pending" do
    visit '/profile'
    expect(page).to_not have_link("My Orders")

    visit cart_path
    click_link ("#{@address_1.address_type} Address: #{@address_1.address} #{@address_1.city}, #{@address_1.state} #{@address_1.zip}")

    click_on("Create Order")
    order_1 = Order.last
    item_1 = order_1.items.last
    item_order_1 = order_1.item_orders.last
    visit "/profile/orders/#{order_1.id}"
    click_link "Cancel Order"
    expect(item_order_1.status).to eq("unfulfilled")
    expect(current_path).to eq("/profile")
    expect(page).to have_content("Order #{order_1.id} has been cancelled")
    visit "/profile/orders/#{order_1.id}"
    expect(page).to have_content("Order status: cancelled")

  end
  it "I cannot cancel my orders if status is shipped" do
    @order_2 = @regular_user.orders.create(address_id: @address_1.id, status: 1)
    @itemorder_4 = ItemOrder.create(order_id: @order_2.id, item_id: @tire.id, quantity: 1, price: 100, status: 1)
    @order_3 = @regular_user.orders.create(address_id: @address_1.id, status: 2)
    @itemorder_6 = ItemOrder.create(order_id: @order_3.id, item_id: @pencil.id, quantity: 100, price: 2, status: 1)

    visit "/profile/orders/#{@order_3.id}"
    expect(page).to_not have_link("Cancel Order")
    visit "/profile/orders/#{@order_2.id}"
    expect(page).to have_link("Cancel Order")
  end
end
