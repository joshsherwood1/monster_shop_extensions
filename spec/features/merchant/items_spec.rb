require 'rails_helper'

describe "As a mechant admin" do
  before(:each) do
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 11234)
    @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @bike_shop.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @user = User.create(name: "alec", address: "234 Main", city: "Denver", state: "CO", zip: 80204, email: "a@gmail.com", password: "password", role: 2, merchant_id: @bike_shop.id)
    @order = @user.orders.create(name: "Sam Jackson", address: "234 Main St", city: "Seattle", state: "Washington", zip: 99987, status: 0)
    ItemOrder.create(order_id: @order.id, item_id: @paper.id, quantity: 2, price: 20)
    @merchant_admin = User.create(name: "alec", address: "234 Main", city: "Denver", state: "CO", zip: 80204, email: "alec@gmail.com", password: "password", role: 2, merchant_id: @bike_shop.id)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_admin)
  end

  it 'As a Merchant Admin I see a button to delete items that have never been ordered' do
    visit '/merchant/items'

    within "#merchant-item-#{@paper.id}" do
      expect(page).to_not have_button('Delete')
    end

    within "#merchant-item-#{@tire.id}" do
      expect(page).to have_button('Delete')
      click_button 'Delete'
    end
    
    expect(current_path).to eq("/merchant/items")
    expect(page).to have_content("#{@tire.name} has been deleted")
    expect(page).to_not have_content("#{@tire.description}")
    expect(page).to_not have_content("#{@tire.price}")
    expect(page).to_not have_css("img[src*='#{@tire.image}']")
    expect(page).to_not have_content("#{@tire.inventory}")
  end
end
