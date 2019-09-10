require 'rails_helper'

describe "As a mechant employee or admin" do
  before(:each) do
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 11234)
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @bike_shop.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @bike_shop.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    merchant_employee = User.create(  name: "alec",
                        address: "234 Main",
                        city: "Denver",
                        state: "CO",
                        zip: 80204,
                        email: "alec@gmail.com",
                        password: "password",
                        role: 1,
                        merchant_id: @bike_shop.id)

    @regular_user =  User.create!(  name: "alec",
                    address: "234 Main",
                    city: "Denver",
                    state: "CO",
                    zip: 80204,
                    email: "5@gmail.com",
                    password: "password"
                  )
    @order_1 = @regular_user.orders.create(name: "Sam Jackson", address: "234 Main St", city: "Seattle", state: "Washington", zip: 99987, status: 0)
    @order_2 = @regular_user.orders.create(name: "Sam Jackson", address: "234 Main St", city: "Seattle", state: "Washington", zip: 99987, status: 0)
    @order_3 = @regular_user.orders.create(name: "Sam Jackson", address: "234 Main St", city: "Seattle", state: "Washington", zip: 99987, status: 0)
    @itemorder = ItemOrder.create(order_id: @order_1.id, item_id: @tire.id, quantity: 2, price: 100)
    @itemorder_2 = ItemOrder.create(order_id: @order_1.id, item_id: @paper.id, quantity: 2, price: 20)
    @itemorder_3 = ItemOrder.create(order_id: @order_1.id, item_id: @pencil.id, quantity: 3, price: 2)
    @itemorder_4 = ItemOrder.create(order_id: @order_2.id, item_id: @tire.id, quantity: 1, price: 100)
    @itemorder_5 = ItemOrder.create(order_id: @order_2.id, item_id: @pencil.id, quantity: 4, price: 2)
    @itemorder_6 = ItemOrder.create(order_id: @order_3.id, item_id: @pencil.id, quantity: 101, price: 2)

    visit '/login'

    fill_in :email, with: merchant_employee.email
    fill_in :password, with: merchant_employee.password

    click_button "Log In"
  end

  it 'When I visit an order show page from my dashboard, I can click link to fulfill item. Link will be replaced with message that item has been fulfilled, show a flash message that item has been fulfilled, and items inventory is reduced by item quantity in order' do
    visit "/items/#{@paper.id}"
    expect(page).to have_content("Inventory: 3")

    visit '/merchant'
    click_link "#{@order_1.id}"
    expect(current_path).to eq("/orders/#{@order_1.id}")

    within "#item-#{@tire.id}" do
      expect(page).to_not have_link("Fulfill #{@tire.name}")
    end

    within "#item-#{@paper.id}" do
      expect(page).to have_link("Fulfill #{@paper.name}")
      click_link("Fulfill #{@paper.name}")
    end

    expect(current_path).to eq("/orders/#{@order_1.id}")
    expect(page).to have_content("#{@paper.name} is now fulfilled")
    within "#item-#{@paper.id}" do
      expect(page).to_not have_link("Fulfill #{@paper.name}")
      expect(page).to have_content("#{@paper.name} is fulfilled")
    end
    visit "/items/#{@paper.id}"
    expect(page).to have_content("Inventory: 1")
  end

  it 'When I visit an order show page from my dashboard, if order quantity for item is greater than item inventory, I see message indicating so' do
    visit "/items/#{@pencil.id}"
    expect(page).to have_content("Inventory: 100")

    visit '/merchant'
    click_link "#{@order_3.id}"
    expect(current_path).to eq("/orders/#{@order_3.id}")

    within "#item-#{@pencil.id}" do
      expect(page).to_not have_link("Fulfill #{@pencil.name}")
      expect(page).to have_content("#{@pencil.name} cannot be fulfilled at this time since there is not enough inventory for item")
    end
  end
end
