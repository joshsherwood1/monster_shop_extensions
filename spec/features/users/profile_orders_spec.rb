require 'rails_helper'

describe "when regular user visits cart" do
  before :each do
    @regular_user = User.create!(  name: "alec",
      address: "234 Main",
      city: "Denver",
      state: "CO",
      zip: 80204,
      email: "5@gmail.com",
      password: "password"
    )
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

  #test for user story 24
  it "when I have orders I see a link called 'My Orders' that takes me to my orders index" do
    visit '/profile'
    expect(page).to_not have_link("My Orders")

    visit cart_path
    click_link "Checkout"
    fill_in :name, with: @regular_user.name
    fill_in :address, with: @regular_user.address
    fill_in :city, with: @regular_user.city
    fill_in :state, with: @regular_user.state
    fill_in :zip, with: @regular_user.zip
    click_button "Create Order"

    visit '/profile'

    within ".my-orders-link" do
      expect(page).to have_link("My Orders")
      click_link "My Orders"
    end

    expect(current_path).to eq('/profile/orders')
  end

  it "user sees all order info on profile orders page" do
    visit cart_path
    click_link "Checkout"
    fill_in :name, with: @regular_user.name
    fill_in :address, with: @regular_user.address
    fill_in :city, with: @regular_user.city
    fill_in :state, with: @regular_user.state
    fill_in :zip, with: @regular_user.zip
    click_button "Create Order"

    order = Order.last
    within "#order-info-#{order.id}" do
      expect(page).to have_content("Date created: #{order.created_at.strftime("%d %b %y")}")
      expect(page).to have_content("Last update: #{order.updated_at.strftime("%d %b %y")}")
      expect(page).to have_content("Order status: #{order.status}")
      expect(page).to have_content("Total items: #{order.total_quantity}")
      expect(page).to have_content("Grand total: $#{order.grandtotal}")
      expect(page).to have_link("Order ID: #{order.id}")
      click_link("Order ID: #{order.id}")
    end

    expect(current_path).to eq("/profile/orders/#{order.id}")
  end
end
