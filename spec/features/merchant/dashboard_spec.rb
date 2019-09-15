require 'rails_helper'

describe "As a mechant employee" do
  before(:each) do
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 11234, enabled?: true)
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @bike_shop.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @bike_shop.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    merchant_employee = User.create(  name: "alec",
                        email: "alec@gmail.com",
                        password: "password",
                        role: 1,
                        merchant_id: @bike_shop.id)

    @regular_user =  User.create!(  name: "alec",
                    email: "5@gmail.com",
                    password: "password"
                  )
    merchant_employee.addresses.create(address: "234 Main", city: "Denver", state: "CO", zip: 80204)
    @address_1 = @regular_user.addresses.create(address: "234 Main", city: "Denver", state: "CO", zip: 80204)

    @order_1 = @regular_user.orders.create(address_id: @address_1.id, status: 0)
    @order_2 = @regular_user.orders.create(address_id: @address_1.id, status: 0)
    @itemorder = ItemOrder.create(order_id: @order_1.id, item_id: @tire.id, quantity: 2, price: 100)
    ItemOrder.create(order_id: @order_1.id, item_id: @paper.id, quantity: 2, price: 20, merchant_id: @bike_shop.id)
    ItemOrder.create(order_id: @order_1.id, item_id: @pencil.id, quantity: 3, price: 2, merchant_id: @bike_shop.id)
    ItemOrder.create(order_id: @order_2.id, item_id: @tire.id, quantity: 1, price: 100, merchant_id: @meg.id)
    ItemOrder.create(order_id: @order_2.id, item_id: @pencil.id, quantity: 4, price: 2, merchant_id: @bike_shop.id)

    visit '/login'

    fill_in :email, with: merchant_employee.email
    fill_in :password, with: merchant_employee.password

    click_button "Log In"
  end

  it "I can navigate to the merchant dashboard and see the name and full address of the merchant I work for" do
    visit '/merchant'

    expect(page).to have_content("Your merchant information")
    expect(page).to have_content("#{@bike_shop.name}")
    expect(page).to have_content("#{@bike_shop.address}")
    expect(page).to have_content("#{@bike_shop.city}")
    expect(page).to have_content("#{@bike_shop.state}")
    expect(page).to have_content("#{@bike_shop.zip}")
  end

  it 'When I visit my dashboard I see a link to view all the items owned by the merchant' do
    visit '/merchant'
    click_link 'View My Current Items'
    expect(current_path).to eq('/merchant/items')
    expect(page).to have_content("#{@paper.name}")
    expect(page).to have_content("#{@paper.description}")
    expect(page).to have_content("#{@paper.price}")
    expect(page).to have_css("img[src*='#{@paper.image}']")
    expect(page).to have_content("#{@paper.inventory}")
  end

  it 'When I visit an order show page I see the customer info and order info specifically for my merchant' do
    visit '/merchant'
    click_link "#{@order_1.id}"
    expect(current_path).to eq("/merchant/orders/#{@order_1.id}")
    expect(page).to have_content("#{@regular_user.name}")
    expect(page).to have_content("#{@address_1.address}")
    expect(page).to have_content("#{@address_1.city}")
    expect(page).to have_content("#{@address_1.state}")
    expect(page).to have_content("#{@address_1.zip}")
    expect(page).to have_content("#{@paper.name}")
    expect(page).to have_css("img[src*='#{@paper.image}']")
    expect(page).to have_content("#{@paper.price}")
    expect(page).to have_content("#{@pencil.name}")
    expect(page).to have_css("img[src*='#{@pencil.image}']")
    expect(page).to have_content("#{@pencil.price}")
    expect(page).to_not have_content("#{@tire.name}")
    expect(page).to_not have_css("img[src*='#{@tire.image}']")
    expect(page).to have_content("#{@itemorder.quantity}")
  end

  it "the merchant dashboard shows all pending orders that have items that my merchant sells" do
    visit '/merchant'

    expect(page).to have_content("Pending Orders:")
    within "#merchant-dashboard-order-#{@order_1.id}" do
      expect(page).to have_link("#{@order_1.id}")
      expect(page).to have_content("#{@order_1.created_at.strftime("%d %b %y")}")
      expect(page).to have_content("Total Quantity of #{@bike_shop.name} items in this order: 5")
      expect(page).to have_content("Grand Total of #{@bike_shop.name} items in this order: $46.00")
    end
    within "#merchant-dashboard-order-#{@order_2.id}" do
      expect(page).to have_link("#{@order_2.id}")
      expect(page).to have_content("#{@order_2.created_at.strftime("%d %b %y")}")
      expect(page).to have_content("Total Quantity of #{@bike_shop.name} items in this order: 4")
      expect(page).to have_content("Grand Total of #{@bike_shop.name} items in this order: $8.00")
    end
  end
end
