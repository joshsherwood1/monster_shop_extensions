require 'rails_helper'

describe "As a mechant employee" do
  before(:each) do
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 11234)
    merchant_employee = User.create(  name: "alec",
                        address: "234 Main",
                        city: "Denver",
                        state: "CO",
                        zip: 80204,
                        email: "alec@gmail.com",
                        password: "password",
                        role: 1,
                        merchant_id: @bike_shop.id)
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
end
