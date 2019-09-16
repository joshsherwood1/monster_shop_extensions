require 'rails_helper'

RSpec.describe "Address Deleting" do
  describe "As a registered user" do
    before :each do
      @user = User.create(name: 'Christopher', email: 'christopher32234@email.com', password: 'p@ssw0rd', role: 0)
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
      visit '/login'

      fill_in :email, with: @user.email
      fill_in :password, with: @user.password

      click_button "Log In"
    end
    it "I can delete an address" do

      visit "profile"

      within "#address-#{@address_home.id}" do
        expect(page).to have_link("Delete this address")
        click_link("Delete this address")
      end

      expect(current_path).to eq('/profile')
      expect(page).to_not have_css("#address-#{@address_home.id}")
      expect(page).to_not have_content("Address: #{@address_home.address}")
      expect(page).to_not have_content("City: #{@address_home.city}")
      expect(page).to_not have_content("State: #{@address_home.state}")
      expect(page).to_not have_content("Zip Code: #{@address_home.zip}")
    end

    it "I can't delete or edit an addressed that has had an order shipped to it" do
      visit "profile"
      within "#address-#{@address_2.id}" do
        expect(page).to_not have_link("Delete this address")
        expect(page).to have_content("This address cannot be edited at this time since it is used in an order")
        expect(page).to have_content("This address cannot be deleted at this time since it is used in an order")
      end
    end
  end
end
