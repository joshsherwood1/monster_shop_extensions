require 'rails_helper'

describe "Admin can see all orders" do
  before :each do
    @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    @admin = User.create(name: 'Christopher', address: '123 Oak Ave', city: 'Denver', state: 'CO', zip: 80021, email: 'christopher@email.com', password: 'p@ssw0rd', role: 3)
    @user_1 = User.create!(  name: "alec", address: "234 Main", city: "Denver", state: "CO", zip: 80204, email: "5@gmail.com", password: "password")
    @user_2 = User.create!(  name: "josh", address: "234 Main", city: "Denver", state: "CO", zip: 80204, email: "6@gmail.com", password: "password")
    @order_2 = @user_2.orders.create!( name: "alec", address: "234 Main", city: "Denver", state: "CO", zip: 80204, status: 0)
    @order_5 = @user_2.orders.create!( name: "alec", address: "234 Main", city: "Denver", state: "CO", zip: 80204, status: 3)
    @order_3 = @user_2.orders.create!( name: "alec", address: "234 Main", city: "Denver", state: "CO", zip: 80204, status: 1)
    @order_4 = @user_1.orders.create!( name: "alec", address: "234 Main", city: "Denver", state: "CO", zip: 80204, status: 2)
    @order_1 = @user_1.orders.create!( name: "alec", address: "234 Main", city: "Denver", state: "CO", zip: 80204, status: 0)
    @item_order_1 = @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 2)
    @item_order_2 = @order_1.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 2)
    @item_order_3 = @order_1.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 2)
    @item_order_4 = @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 2)
    @item_order_5 = @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 2)
    @item_order_6 = @order_3.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 7)

    visit '/login'

    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password

    click_button "Log In"
  end

  it "they can see order details" do
    visit '/admin'
    expect(page).to have_content(@order_1.id)
    expect(page).to have_content(@order_2.id)
    expect(page).to have_content(@order_3.id)
    expect(page).to have_content(@order_4.id)
    expect(page).to have_content(@order_5.id)

    within "#order-id-#{@order_1.id}" do
      expect(page).to have_content("Placed by: #{@order_1.name}")
      expect(page).to have_content("Date created: #{@order_1.created_at.strftime("%d %b %y")}")
      expect(page).to have_content("Order Status: #{@order_1.status}")
      click_link("Placed by: #{@order_1.name}")
    end
    expect(current_path).to eq("/admin/users/#{@user_1.id}")
    expect(page).to have_content(@user_1.name)
    expect(page).to_not have_link('Edit Profile')
  end

  it "they can see button to ship packaged orders, and when ship button is clicked,
    the status of the order changes to shipped" do
    visit '/admin'
    within "#order-id-#{@order_3.id}" do
      expect(page).to have_content("Order Status: packaged")
      expect(page).to have_button("Ship Order #{@order_3.id}")
      click_button("Ship Order #{@order_3.id}")
    end
    expect(current_path).to eq('/admin')
    within "#order-id-#{@order_3.id}" do
      expect(page).to have_content("Order Status: shipped")
    end
  end
end
