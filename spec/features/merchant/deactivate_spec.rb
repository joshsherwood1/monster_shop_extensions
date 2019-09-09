require 'rails_helper'

describe "As a mechant admin" do
  before(:each) do
    @bike_shop = Merchant.create!(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 11234)
    merchant_admin = User.create!(  name: "alec",
                        address: "234 Main",
                        city: "Denver",
                        state: "CO",
                        zip: 80204,
                        email: "alec@gmail.com",
                        password: "password",
                        role: 2,
                        merchant_id: @bike_shop.id)
    visit '/login'

    fill_in :email, with: merchant_employee.email
    fill_in :password, with: merchant_employee.password

    click_button "Log In"
  end

#   As a merchant admin
# When I visit my items page
# I see a link or button to deactivate the item next to each item that is active
# And I click on the "deactivate" button or link for an item
# I am returned to my items page
# I see a flash message indicating this item is no longer for sale
# I see the item is now inactive
end
