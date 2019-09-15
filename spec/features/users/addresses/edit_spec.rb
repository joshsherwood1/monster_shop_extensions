require 'rails_helper'

RSpec.describe "Address Editing" do
  describe "As a registered user" do
    before :each do
      @user = User.create(name: 'Christopher', email: 'christopher@email.com', password: 'p@ssw0rd', role: 0)
      @address_home = @user.addresses.create!(address: "1600 Pennsylvania Ave NW", city: "Washington", state: "DC", zip: 20500)
      visit '/login'

      fill_in :email, with: @user.email
      fill_in :password, with: @user.password

      click_button "Log In"
    end
    it "I can edit an address from my profile page by clicking on a link and filling out a form" do
      visit '/profile'
      within "#address-#{@address_home.id}" do
        expect(page).to have_link("Edit this address")
        click_link("Edit this address")
      end

      expect(current_path).to eq("/profile/addresses/#{@address_home.id}/edit")

      expect(find_field(:address_type).value).to eq 'home'
      expect(find_field(:address).value).to eq "1600 Pennsylvania Ave NW"
      expect(find_field(:city).value).to eq("Washington")
      expect(find_field(:state).value).to eq 'DC'
      expect(find_field(:zip).value).to eq '20500'
      expect(page).to have_button("Update Address")

      fill_in :address_type, with: "Home 3"
      fill_in :address, with: "678 Main St."
      fill_in :zip, with: 28090

      click_button("Update Address")

      expect(current_path).to eq("/profile")

      within "#address-#{@address_home.id}" do
        expect(page).to have_content("Address Type: Home 3")
        expect(page).to have_content("Address: 678 Main St.")
        expect(page).to have_content("City: Washington")
        expect(page).to have_content("State: DC")
        expect(page).to have_content("Zip Code: 28090")
      end

    end
  end
end
