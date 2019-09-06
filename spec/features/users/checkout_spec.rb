require 'rails_helper'

describe "when regular user visits cart" do
  it "they can checkout and and order is created associated with user" do
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

      @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create!(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create!(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"
      visit '/login'
      fill_in :email, with: @regular_user.email
      fill_in :password, with: @regular_user.password
      click_button "Log In"
    end

    visit cart_path
    click_link "Checkout"

    fill_in :name, with: @regular_user.name
    fill_in :address, with: @regular_user.address
    fill_in :city, with: @regular_user.city
    fill_in :state, with: @regular_user.state
    fill_in :zip, with: @regular_user.zip

    click_button "Create Order"

    expect(current_path).to eq("/profile/orders")
    order = Order.last
    expect
  end
end
# As a registered user
# When I add items to my cart
# And I visit my cart
# I see a button or link indicating that I can check out
# And I click the button or link to check out
# An order is created in the system, which has a status of "pending"
# That order is associated with my user
# I am taken to my orders page ("/profile/orders")
# I see a flash message telling me my order was created
# I see my new order listed on my profile orders page
# My cart is now empty
