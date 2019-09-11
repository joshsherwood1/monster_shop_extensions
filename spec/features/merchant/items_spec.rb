require 'rails_helper'

describe "As a mechant admin" do
  before(:each) do
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 11234)
    @paper = @bike_shop.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
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

    expect(current_path).to eq('/merchant/items')
    expect(page).to have_content("#{@tire.name} has been deleted")
    expect(page).to_not have_content("#{@tire.description}")
    expect(page).to_not have_content("#{@tire.price}")
    expect(page).to_not have_css("img[src*='#{@tire.image}']")
    expect(page).to_not have_content("#{@tire.inventory}")
  end

  it 'I have a link to add new items. These new items will be enabled and available for sale.' do
    visit '/merchant/items'
    click_link 'Add a New Item'
    expect(current_path).to eq('/merchant/items/new')

    name = 'Paint'
    description = 'Change the color'
    image_url = 'https://www.google.com/url?sa=i&source=imgres&cd=&ved=2ahUKEwjQ4YqU_sTkAhXDrZ4KHW6EBv8QjRx6BAgBEAQ&url=https%3A%2F%2Fwww.paint.org%2F&psig=AOvVaw2VOzStgtf0UEdDbD7r1utX&ust=1568161284764759'
    price = 25
    inventory = 5

    fill_in 'Name', with: name
    fill_in 'Description', with: description
    fill_in 'Image', with: image_url
    fill_in 'Price', with: price
    fill_in 'Inventory', with: inventory
    click_button 'Create Item'

    paint = Item.last

    expect(current_path).to eq('/merchant/items')
    expect(page).to have_content("#{paint.name} has been created")
    expect(page).to have_content(paint.description.to_s)
    expect(page).to have_content(paint.price.to_s)
    expect(page).to have_css("img[src*='#{paint.image}']")
    expect(page).to have_content(paint.inventory.to_s)
  end

  it 'I fill out an item form incorrectly, the form stays populated, I get a flash message' do
    visit '/merchant/items/new'

    name = ''
    description = ''
    image_url = 'https://www.google.com/url?sa=i&source=imgres&cd=&ved=2ahUKEwjQ4YqU_sTkAhXDrZ4KHW6EBv8QjRx6BAgBEAQ&url=https%3A%2F%2Fwww.paint.org%2F&psig=AOvVaw2VOzStgtf0UEdDbD7r1utX&ust=1568161284764759'
    price = 25
    inventory = 5

    fill_in 'Name', with: name
    fill_in 'Description', with: description
    fill_in 'Image', with: image_url
    fill_in 'Price', with: price
    fill_in 'Inventory', with: inventory
    click_button 'Create Item'

    expect(find_field('Price').value).to eq(price.to_s)
    expect(find_field('Inventory').value).to eq(inventory.to_s)
  end

  it 'I can edit an item. All the rules for creating an item apply.' do
    visit '/merchant/items'

    within "#merchant-item-#{@tire.id}" do
      click_link 'Edit'
    end

    expect(current_path).to eq("/merchant/items/#{@tire.id}/edit")

    expect(current_path).to eq("/merchant/items/#{@tire.id}/edit")\

    expect(find_field('Name').value).to eq 'Gatorskins'
    expect(find_field('Description').value).to eq "They'll never pop!"
    expect(find_field('Image').value).to eq('https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588')
    expect(find_field('Price').value).to eq '100'
    expect(find_field('Inventory').value).to eq '12'

    description = ''
    fill_in 'Description', with: description
    click_button 'Update Item'
    expect(page).to have_content("Description can't be blank")

    description = 'They pop sometimes'
    fill_in 'Description', with: description
    click_button 'Update Item'

    expect(current_path).to eq('/merchant/items')
    expect(page).to have_content("#{@tire.name} has been updated")
    expect(page).to_not have_content("They'll never pop!")
    expect(page).to have_content('They pop sometimes')
  end
end
