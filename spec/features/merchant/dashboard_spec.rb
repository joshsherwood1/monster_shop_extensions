require 'rails_helper'

describe "As a mechant employee" do
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

    regular_user =  User.create!(  name: "alec",
                    address: "234 Main",
                    city: "Denver",
                    state: "CO",
                    zip: 80204,
                    email: "5@gmail.com",
                    password: "password"
                  )
    @order_1 = regular_user.orders.create(name: "Sam Jackson", address: "223 Main St", city: "Seattle", state: "Washington", zip: 99987, status: 0)
    @order_2 = regular_user.orders.create(name: "Sam Jackson", address: "223 Main St", city: "Seattle", state: "Washington", zip: 99987, status: 0)
    ItemOrder.create(order_id: @order_1.id, item_id: @tire.id, quantity: 2, price: 100)
    ItemOrder.create(order_id: @order_1.id, item_id: @paper.id, quantity: 2, price: 20)
    ItemOrder.create(order_id: @order_1.id, item_id: @pencil.id, quantity: 3, price: 2)
    ItemOrder.create(order_id: @order_2.id, item_id: @tire.id, quantity: 1, price: 100)
    ItemOrder.create(order_id: @order_2.id, item_id: @pencil.id, quantity: 4, price: 2)

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

  it "the merchant dashboard shows all pending orders that have items that my merchant sells" do
    visit '/merchant'

    save_and_open_page

    expect(page).to have_content("Pending Orders:")
    expect(page).to have_link("#{@order_1.id}")
    expect(page).to have_content("#{@order_1.created_at}")
    expect(page).to have_content("Total Quantity of #{@bike_shop.name} items in this order: 5")
    expect(page).to have_content("Grand Total of #{@bike_shop.name} items in this order: $46.00")

    expect(page).to have_link("#{@order_2.id}")
    expect(page).to have_content("#{@order_2.created_at}")
    expect(page).to have_content("Total Quantity of #{@bike_shop.name} items in this order: 4")
    expect(page).to have_content("Grand Total of #{@bike_shop.name} items in this order: $8.00")
  end
end
