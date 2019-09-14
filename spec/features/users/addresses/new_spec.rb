require 'rails_helper'

RSpec.describe "Address Creation" do
  describe "As a registered user" do
    before :each do
      @user = User.create(name: 'Christopher', email: 'christopher@email.com', password: 'p@ssw0rd', role: 0)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      @address_home = @user.addresses.create!(address: "1600 Pennsylvania Ave NW", city: "Washington", state: "DC", zip: 20500)
    end
    it "I can create a new address from my profile page by clicking on a link and filling out a form" do
      visit '/profile'
      expect(page).to have_link("Create a new address")
      click_link("Create a new address")
      expect(current_path).to eq("/profile/addresses/new")

      expect(page).to have_field(:address_type)
      expect(page).to have_field(:address)
      expect(page).to have_field(:city)
      expect(page).to have_field(:state)
      expect(page).to have_field(:zip)
      expect(page).to have_button("Create Address")

      address_type = "Home 2"
      address = "123 Sesame St."
      city = "NYC"
      state = "New York"
      zip = 10001

      fill_in :address_type, with: address_type
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip

      click_button("Create Address")

      expect(current_path).to eq("/profile")

      expect(page).to have_content("Address Type: #{address_type}")
      expect(page).to have_content("Address: #{address}")
      expect(page).to have_content("City: #{city}")
      expect(page).to have_content("State: #{state}")
      expect(page).to have_content("Zip Code: #{zip}")

    end
  end
end
