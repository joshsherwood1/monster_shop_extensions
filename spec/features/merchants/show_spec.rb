require 'rails_helper'

RSpec.describe 'merchant show page', type: :feature do
  describe 'As a user' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
    end

    it 'I can see a merchants name, address, city, state, zip' do
      visit "/merchants/#{@bike_shop.id}"

      expect(page).to have_content("Brian's Bike Shop")
      expect(page).to have_content("123 Bike Rd.\nRichmond, VA 23137")
    end

    it 'I can see a link to visit the merchant items' do
      visit "/merchants/#{@bike_shop.id}"

      expect(page).to have_link("All #{@bike_shop.name} Items")

      click_on "All #{@bike_shop.name} Items"

      expect(current_path).to eq("/merchants/#{@bike_shop.id}/items")
    end

    it 'I see cities where items have been ordered' do
      @regular_user_2 = User.create!(  name: "alec", email: "5655@gmail.com", password: "password")
      @address_6 = @regular_user_2.addresses.create!(address: "234 Main", city: "Denver", state: "CO", zip: 80204)
      @address_7 = @regular_user_2.addresses.create!(address: "987 Evergreen Dr", city: "Seattle", state: "WA", zip: 74132, address_type: "Work")
      @order_1 = @regular_user_2.orders.create!(address_id: @address_6.id)
      @order_2 = @regular_user_2.orders.create!(address_id: @address_7.id)
      @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      ItemOrder.create!(merchant_id: @meg.id, item_id: @tire.id, price: 100, quantity: 1, order_id: @order_1.id)
      ItemOrder.create!(merchant_id: @meg.id, item_id: @tire.id, price: 100, quantity: 1, order_id: @order_2.id)

      visit "/merchants/#{@meg.id}"

      expect(page).to have_content("Cities that order these items:\nDenver\nSeattle")
    end
  end
end
