require 'rails_helper'

describe 'User Cart Checkout' do
  describe "when a user visits their cart with items in their cart'" do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      @user = User.create(name: 'Christopher', address: '123 Oak Ave', city: 'Denver', state: 'CO', zip: 80021, email: 'christopher@email.com', password: 'p@ssw0rd', role: 0)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end
    it 'they will not see a message that says that they have to login or register to checkout their items, and they will see a link to checkout' do

      visit "/items/#{@paper.id}"
      click_on "Add To Cart"

      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"

      within 'nav' do
        expect(page).to have_content("Cart: 2")
      end

      visit "/cart"
      expect(page).to_not have_content("You must login or register in order to checkout")
      expect(page).to have_link("Checkout")
    end
  end
end
