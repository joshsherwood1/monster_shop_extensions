require 'rails_helper'

describe "When a user who is already logged in visits login page" do
  before :each do
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 11234)

    @regular_user = User.create!(  name: "alec",
      email: "1@gmail.com",
      password: "password"
    )
    @merchant_user = User.create!(  name: "josh",
      email: "2@gmail.com",
      password: "password",
      role: 1,
      merchant_id: @bike_shop.id
    )
    @admin_user = User.create!(  name: "chris",
      email: "3@gmail.com",
      password: "password",
      role: 3
    )

    @merchant_user.addresses.create!(address: "1600 Pennsylvania Ave NW", city: "Washington", state: "DC", zip: 20500)
    @regular_user.addresses.create!(address: "1600 Pennsylvania Ave NW", city: "Washington", state: "DC", zip: 20500)
    @admin_user.addresses.create!(address: "1600 Pennsylvania Ave NW", city: "Washington", state: "DC", zip: 20500)

  end

  it "regular users are redirected to profile" do
    visit '/login'

    fill_in :email, with: @regular_user.email
    fill_in :password, with: @regular_user.password

    click_button "Log In"
    visit '/login'
    expect(current_path).to eq('/profile')
    expect(page).to have_content("Already logged in")
  end

  it "merchant users are redirected to dashboard" do
    visit '/login'

    fill_in :email, with: @merchant_user.email
    fill_in :password, with: @merchant_user.password

    click_button "Log In"
    visit '/login'
    expect(current_path).to eq('/merchant')
    expect(page).to have_content("Already logged in")
  end

  it "admin users are redirected to dashboard" do
    visit '/login'

    fill_in :email, with: @admin_user.email
    fill_in :password, with: @admin_user.password

    click_button "Log In"
    visit '/login'
    expect(current_path).to eq('/admin')
    expect(page).to have_content("Already logged in")
  end
end
