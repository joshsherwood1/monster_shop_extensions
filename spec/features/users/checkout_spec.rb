require 'rails_helper'

describe "when regular user visits cart" do
  before :each do
    @other_user = User.create!(  name: "Alec", email: "8765@gmail.com", password: "password")
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
  it "they can checkout and and order is created associated with user" do
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
    expect(order.status).to eq("pending")
    expect(order.user_id).to eq(@regular_user.id)
    expect(page).to have_content("Order Created!")

    visit '/cart'
    expect(page).to have_content("Cart is currently empty")
    expect(page).to_not have_link("Checkout")

  end

  it "they cannot checkout if they have no addresses, but they can once they have created an address" do

    visit '/login'
    fill_in :email, with: @other_user.email
    fill_in :password, with: @other_user.password
    click_button "Log In"
    visit cart_path
    expect(page).to have_content("Please add an address to checkout")
    expect(page).to have_link("add an address")
    click_link("add an address")

    expect(current_path).to eq("/profile/addresses/new")

    address_type = "Home 2"
    address = "123 Sesame St."
    city = "NYC"
    state = "New York"
    zip = 10001

    fill_in :address_type, with: address_type
    fill_in :address, with: address
    fill_in :city, with: city
    fill_in :state, with: state
    fill_in :zip, with: zip

    click_button("Create Address")

    expect(current_path).to eq("/profile")

    visit cart_path

    expect(page).to have_link("Home 2 Address: 123 Sesame St. NYC, New York 10001")

  end
end
