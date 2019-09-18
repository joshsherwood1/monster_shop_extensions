require 'rails_helper'

describe "As a mechant employee or admin" do
  before(:each) do
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 11234)
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @bike_shop.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @bike_shop.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    merchant_employee = User.create(  name: "alec",
                        email: "alec@gmail.com",
                        password: "password",
                        role: 1,
                        merchant_id: @bike_shop.id)
    merchant_employee.addresses.create(address: "234 Main", city: "Denver", state: "CO", zip: 80204)


    @regular_user =  User.create!(  name: "alec",
                    email: "5@gmail.com",
                    password: "password"
                  )
    @address_1 = @regular_user.addresses.create(address: "234 Main", city: "Denver", state: "CO", zip: 80204)

    @order_1 = @regular_user.orders.create!(address_id: @address_1.id, status: 0)
    @order_2 = @regular_user.orders.create!(address_id: @address_1.id, status: 0)
    @order_3 = @regular_user.orders.create!(address_id: @address_1.id, status: 0)
    @itemorder = ItemOrder.create(order_id: @order_1.id, item_id: @tire.id, quantity: 2, price: 100, merchant_id: @meg.id)
    @itemorder_2 = ItemOrder.create(order_id: @order_1.id, item_id: @paper.id, quantity: 2, price: 20, merchant_id: @bike_shop.id)
    @itemorder_3 = ItemOrder.create(order_id: @order_1.id, item_id: @pencil.id, quantity: 3, price: 2, merchant_id: @bike_shop.id)
    @itemorder_4 = ItemOrder.create(order_id: @order_2.id, item_id: @tire.id, quantity: 1, price: 100, merchant_id: @meg.id)
    @itemorder_5 = ItemOrder.create(order_id: @order_2.id, item_id: @pencil.id, quantity: 4, price: 2, merchant_id: @bike_shop.id)
    @itemorder_6 = ItemOrder.create(order_id: @order_3.id, item_id: @pencil.id, quantity: 101, price: 2, merchant_id: @bike_shop.id)
    @coupon_1 = @bike_shop.coupons.create!(name: "CODE-20-PERCENT-OFF-BIKESHOP", percent_off: 20)
    @coupon_2 = @bike_shop.coupons.create!(name: "CODE-5-DOLLARS-OFF-BIKESHOP", amount_off: 5.00)
    visit '/login'

    fill_in :email, with: merchant_employee.email
    fill_in :password, with: merchant_employee.password

    click_button "Log In"
  end

  it 'When I visit my coupon management center, I see all of my coupons and their info' do
    visit "/merchant/coupons"

    within "#coupon-#{@coupon_1.id}" do
      expect(page).to have_content("#{@coupon_1.name}")
      expect(page).to have_content("Discount: 20% off Bike Shop subtotal in cart")
    end
    within "#coupon-#{@coupon_2.id}" do
      expect(page).to have_content("#{@coupon_2.name}")
      expect(page).to have_content("Discount: $5 off Bike Shop subtotal in cart")
    end
  end

  it "I can add a new coupon by clicking a link and being taken to a form where I can fill out that information" do
    visit "/merchant/coupons"
    click_link "Add Coupon"
    expect(current_path).to eq("/merchant/coupons/new")
    expect(page).to have_field(:name)
    expect(page).to have_field(:percent_off)
    expect(page).to have_field(:amount_off)

    name = "CODE-10-DOLLARS-OFF"
    amount_off = 10.00

    fill_in :name, with: name
    fill_in :amount_off, with: amount_off

    click_on "Create Coupon"
    expect(current_path).to eq("/merchant/coupons")
    expect(page).to have_content("CODE-10-DOLLARS-OFF")
    expect(page).to have_content("Discount: $10 off Bike Shop subtotal in cart")
  end

  it "You can only create coupon with a percent off or amount off" do
    visit "/merchant/coupons"
    click_link "Add Coupon"
    expect(current_path).to eq("/merchant/coupons/new")
    expect(page).to have_field(:name)
    expect(page).to have_field(:percent_off)
    expect(page).to have_field(:amount_off)

    name = "CODE-10-DOLLARS-OFF"
    amount_off = 10.00
    percent_off = 15.00

    fill_in :name, with: name
    fill_in :amount_off, with: amount_off
    fill_in :percent_off, with: percent_off

    click_on "Create Coupon"
    expect(page).to have_content("Please choose only a percent off or amount off")
  end

  it "You can only create coupon with a valid number for percent off or amount off" do
    visit "/merchant/coupons"
    click_link "Add Coupon"
    expect(current_path).to eq("/merchant/coupons/new")
    expect(page).to have_field(:name)
    expect(page).to have_field(:percent_off)
    expect(page).to have_field(:amount_off)

    name = "CODE-10-DOLLARS-OFF"
    amount_off = -10.00

    fill_in :name, with: name
    fill_in :amount_off, with: amount_off

    click_on "Create Coupon"
    expect(page).to have_content("Amount off must be greater than 0")
  end

  it "You have to fill out either amount off or percent off to create coupon" do
    visit "/merchant/coupons"
    click_link "Add Coupon"
    expect(current_path).to eq("/merchant/coupons/new")
    expect(page).to have_field(:name)
    expect(page).to have_field(:percent_off)
    expect(page).to have_field(:amount_off)


    click_on "Create Coupon"
    expect(page).to have_content("Name can't be blank, Percent off can't be blank, Percent off is not a number, Amount off can't be blank, and Amount off is not a number")
  end

  it "You can edit a coupon" do
    visit "/merchant/coupons"

    within "#coupon-#{@coupon_2.id}" do
      expect(page).to have_content("#{@coupon_2.name}")
      expect(page).to have_content("Discount: $5 off Bike Shop subtotal in cart")
      click_link "Edit Coupon"
    end

    expect(current_path).to eq("/merchant/coupons/#{@coupon_2.id}/edit")

    expect(page).to have_field(:name)
    expect(page).to have_field(:percent_off)
    expect(page).to have_field(:amount_off)

    name = "CODE-12-DOLLARS-OFF"
    amount_off = 12.00

    fill_in :name, with: name
    fill_in :amount_off, with: amount_off


    click_on "Update Coupon"

    expect(current_path).to eq("/merchant/coupons")

    within "#coupon-#{@coupon_2.id}" do
      expect(page).to have_content("CODE-12-DOLLARS-OFF")
      expect(page).to have_content("Discount: $12 off Bike Shop subtotal in cart")
    end
  end

  it "You can't edit a coupon if all the required fields are not filled out" do
    visit "/merchant/coupons"

    within "#coupon-#{@coupon_2.id}" do
      click_link "Edit Coupon"
    end

    expect(current_path).to eq("/merchant/coupons/#{@coupon_2.id}/edit")

    name = "CODE-12-PERCENT-OFF"
    percent_off = 1.00

    fill_in :name, with: name
    fill_in :percent_off, with: percent_off

    click_on "Update Coupon"

    expect(page).to have_content("Please choose only a percent off or amount off")
  end

  it "You can't edit a coupon if percent_off or amount_off are not valid numbers" do
    visit "/merchant/coupons"

    within "#coupon-#{@coupon_1.id}" do
      click_link "Edit Coupon"
    end

    expect(current_path).to eq("/merchant/coupons/#{@coupon_1.id}/edit")

    name = "CODE-12-PERCENT-OFF"
    percent_off = 101.00

    fill_in :name, with: name
    fill_in :percent_off, with: percent_off

    click_on "Update Coupon"

    expect(page).to have_content("Percent off must be less than 100")
  end

  it "I can delete a coupon" do
    visit "/merchant/coupons"

    within "#coupon-#{@coupon_1.id}" do
      click_link "Delete Coupon"
    end

    expect(current_path).to eq("/merchant/coupons")

    expect(page).to_not have_css("#coupon-#{@coupon_1.id}")
    expect(page).to_not have_content("#{@coupon_1.name}")
    expect(page).to_not have_content("Discount: 20% off Bike Shop subtotal in cart")
  end

  # xit "I can enable or disable a coupon" do
  #   visit "/merchant/coupons"
  #
  #   within "#coupon-#{@coupon_1.id}" do
  #     click_link "Disable Coupon"
  #   end
  #
  #   expect(current_path).to eq("/merchant/coupons")
  #
  #
  #   within "#coupon-#{@coupon_1.id}" do
  #     click_link "Enable Coupon"
  #   end
  #
  #   expect(current_path).to eq("/merchant/coupons")
  #
  #   within "#coupon-#{@coupon_1.id}" do
  #     expect(page).to have_link("Disable Coupon")
  #   end
  # end
end
