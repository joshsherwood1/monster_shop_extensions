require 'rails_helper'

describe("Order Creation") do
  describe "When I check out from my cart" do
    before(:each) do
      @user = User.create!(  name: "alec",
        email: "alec@gmail.com",
        password: "password"
      )
      @address_1 = @user.addresses.create(address: "234 Main", city: "Denver", state: "CO", zip: 80204)
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

      visit '/login'

      fill_in :email, with: @user.email
      fill_in :password, with: @user.password

      click_button "Log In"

      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"

    end

    it 'I can create a new order' do
      visit cart_path
      expect(page).to have_link("#{@address_1.address_type} Address: #{@address_1.address} #{@address_1.city}, #{@address_1.state} #{@address_1.zip}")
      click_link("#{@address_1.address_type} Address: #{@address_1.address} #{@address_1.city}, #{@address_1.state} #{@address_1.zip}")
      expect(current_path).to eq("/orders/new/address/#{@address_1.id}")
      click_button("Create Order")

      new_order = Order.last
      expect(current_path).to eq("/profile/orders")

      visit "/orders/#{new_order.id}"

      within '.shipping-address' do
        expect(page).to have_content(@user.name)
        expect(page).to have_content(@address_1.address)
        expect(page).to have_content(@address_1.city)
        expect(page).to have_content(@address_1.state)
        expect(page).to have_content(@address_1.zip)
      end

      within "#item-#{@paper.id}" do
        expect(page).to have_link(@paper.name)
        expect(page).to have_link("#{@paper.merchant.name}")
        expect(page).to have_content("$#{@paper.price}")
        expect(page).to have_content("2")
        expect(page).to have_content("$40")
      end

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_link("#{@tire.merchant.name}")
        expect(page).to have_content("$#{@tire.price}")
        expect(page).to have_content("1")
        expect(page).to have_content("$100")
      end

      within "#item-#{@pencil.id}" do
        expect(page).to have_link(@pencil.name)
        expect(page).to have_link("#{@pencil.merchant.name}")
        expect(page).to have_content("$#{@pencil.price}")
        expect(page).to have_content("1")
        expect(page).to have_content("$2")
      end

      within "#grandtotal" do
        expect(page).to have_content("Total: $142")
      end

      within "#datecreated" do
        expect(page).to have_content(new_order.created_at)
      end
    end
  end
end
