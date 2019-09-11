require 'rails_helper'

describe "Admin user can see all merchants" do
  before :each do
    @regular_user =  User.create!(  name: "alec", address: "234 Main", city: "Denver", state: "CO", zip: 80204, email: "5@gmail.com", password: "password")
    @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210, enabled?: true)
    @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203, enabled?: false)
    @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21)
    @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @bike_shop.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @bike_shop.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    @order_1 = @regular_user.orders.create(name: "Sam Jackson", address: "234 Main St", city: "Seattle", state: "Washington", zip: 99987, status: 0)
    @order_2 = @regular_user.orders.create(name: "Sam Jackson", address: "234 Main St", city: "Seattle", state: "Washington", zip: 99987, status: 0)
    @itemorder = ItemOrder.create(order_id: @order_1.id, item_id: @tire.id, quantity: 2, price: 100)
    ItemOrder.create(order_id: @order_1.id, item_id: @paper.id, quantity: 2, price: 20)
    ItemOrder.create(order_id: @order_1.id, item_id: @pencil.id, quantity: 3, price: 2)
    ItemOrder.create(order_id: @order_2.id, item_id: @tire.id, quantity: 1, price: 100)
    ItemOrder.create(order_id: @order_2.id, item_id: @pencil.id, quantity: 4, price: 2)

    @admin = User.create(name: 'Christopher', address: '123 Oak Ave', city: 'Denver', state: 'CO', zip: 80021, email: 'christopher@email.com', password: 'p@ssw0rd', role: 3)

    visit '/login'

    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password

    click_button "Log In"
  end

  it "When visit index page see merchant info and can disable and enable" do
    visit "/merchants"

    within "#merchant-#{@bike_shop.id}" do
      expect(page).to have_content("Location: #{@bike_shop.city}, #{@bike_shop.state}")
      expect(page).to have_link("Enable")
    end

    within "#merchant-#{@dog_shop.id}" do
      expect(page).to have_link("Disable")
      click_link("Disable")
    end

    expect(current_path).to eq("/merchants")
    @dog_shop.reload
    expect(@dog_shop.enabled?).to eq(false)
    expect(page).to have_content("#{@dog_shop.name} disabled")

    within "#merchant-#{@dog_shop.id}" do
      expect(page).to have_link("Enable")
      click_link("Enable")
    end

    expect(current_path).to eq("/merchants")
    expect(page).to have_content("#{@dog_shop.name} enabled")
  end

  it "Admin can see merchant dashboard" do
    visit "/merchants"
    within "#merchant-#{@bike_shop.id}" do
      click_link(@bike_shop.name)
    end

    expect(current_path).to eq("/admin/merchants/#{@bike_shop.id}")

    expect(page).to have_content("Pending Orders:")
    expect(page).to have_link("#{@order_1.id}")
    expect(page).to have_content("#{@order_1.created_at.strftime("%d %b %y")}")
    expect(page).to have_content("Total Quantity of #{@bike_shop.name} items in this order: 5")
    expect(page).to have_content("Grand Total of #{@bike_shop.name} items in this order: $246.00")
    expect(page).to have_content("Your merchant information")
    expect(page).to have_content("#{@bike_shop.name}")
    expect(page).to have_content("#{@bike_shop.address}")
    expect(page).to have_content("#{@bike_shop.city}")
    expect(page).to have_content("#{@bike_shop.state}")
    expect(page).to have_content("#{@bike_shop.zip}")
  end

  it "when admin disables merchants their items are no longer for sale" do
    visit "/merchants"

    within "#merchant-#{@dog_shop.id}" do
      expect(page).to have_link("Disable")
      click_link("Disable")
    end

    @dog_shop.reload
    @pull_toy.reload
    @dog_bone.reload
    expect(@dog_shop.enabled?).to eq(false)
    expect(@pull_toy.active?).to eq(false)
    expect(@dog_bone.active?).to eq(false)
  end
end
