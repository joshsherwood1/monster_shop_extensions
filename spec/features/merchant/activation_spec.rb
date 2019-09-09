require 'rails_helper'

describe "As a mechant admin" do
  before(:each) do
    @bike_shop = Merchant.create!(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 11234)
    @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @dog_bone = @bike_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    @merchant_admin = @bike_shop.users.create!(  name: "alec",
                        address: "234 Main",
                        city: "Denver",
                        state: "CO",
                        zip: 80204,
                        email: "alec@gmail.com",
                        password: "password",
                        role: 2,
                        merchant_id: @bike_shop.id)
    visit '/login'
    fill_in :email, with: @merchant_admin.email
    fill_in :password, with: @merchant_admin.password
    click_button "Log In"
  end

  it "I can Deactivate items on item page" do
    visit '/merchant/items'
    within "#merchant-item-#{@dog_bone.id}" do
      expect(page).to_not have_link("Deactivate")
    end
    within "#merchant-item-#{@tire.id}" do
      #can get rid of line below once test passing
      expect(page).to have_link("Deactivate")
      click_link "Deactivate"
    end
    expect(current_path).to eq("/merchant/items")
    expect(page).to have_content("#{@tire.name} no longer for sale")
    # expect(@tire.active?).to eq(false)
  end

  it "I can Activate items on item page" do
    visit '/merchant/items'
    within "#merchant-item-#{@tire.id}" do
      expect(page).to_not have_link("Activate")
    end

    within "#merchant-item-#{@dog_bone.id}" do
      expect(page).to have_link("Activate")
      click_link "Activate"
    end
    expect(current_path).to eq("/merchant/items")
    expect(page).to have_content("#{@dog_bone.name} for sale")
  end
end
