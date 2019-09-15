require "rails_helper"

describe "User can access link to their profile" do
  describe "As a user" do
    it "I can see a link on navbar to go to my profile and to logout and I do not see login or register links" do
      visit '/items'

      within 'nav' do
        click_link 'Register'
      end

      name = "alec"
      address = "234 Main"
      city = "Denver"
      state = "CO"
      zip = 80204
      email = "alec@gmail.com"
      password = "password"
      password_confirm = "password"

      fill_in "Name", with: name
      fill_in "Address", with: address
      fill_in "City", with: city
      fill_in "State", with: state
      fill_in "Zip", with: zip
      fill_in "Email", with: email
      fill_in "Password", with: password
      fill_in "Password Confirmation", with: password_confirm

      click_button "Submit"

      expect(current_path).to eq("/profile")
      expect(page).to have_content("Welcome, #{name}")

      visit "/items"
      within ".topnav" do
          expect(page).to have_link("Profile")
          expect(page).to have_link("Logout")
          expect(page).to_not have_link("Login")
          expect(page).to_not have_link("Register")
          expect(page).to have_content("Logged in as #{name}")
      end

      visit "/merchants"
      within ".topnav" do
        expect(page).to have_link("Profile")
        expect(page).to have_link("Logout")
        expect(page).to_not have_link("Login")
        expect(page).to_not have_link("Register")
        expect(page).to have_content("Logged in as #{name}")
      end
    end
  end
end
