require 'rails_helper'

describe 'User Registration' do
  describe 'when user clicks on register' do
    it 'they can fill out a form to register new user' do

      visit '/items'

      within 'nav' do
        click_link 'Register'
      end

      expect(current_path).to eq("/register")

      name = "alec"
      address = "234 Main"
      city = "Denver"
      state = "CO"
      zip = 80204
      email = "alec@gmail.com"
      password = "password"
      password_confirmation = "password"

      fill_in :name, with: name
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip
      fill_in :email, with: email
      fill_in :password, with: password
      fill_in :password_confirmation, with: password_confirmation

      click_button "Submit"

      expect(current_path).to eq("/profile")
      expect(page).to have_content("Welcome, #{name}")
    end

    it 'they have to fill out entire form' do

      visit '/register'


      click_button "Submit"

      expect(page).to have_content("Name can't be blank")
      expect(page).to have_content("City can't be blank")
      expect(page).to have_content("State can't be blank")
      expect(page).to have_content("Zip can't be blank")
      expect(page).to have_content("Email can't be blank")
      expect(page).to have_content("Password can't be blank")
      expect(page).to have_content("Password digest can't be blank")
      expect(page).to have_content("Address can't be blank")

      expect(current_path).to eq("/users")
    end

    it 'they have to use unique email address' do

      user_1 = User.create(  name: "alec",
        address: "234 Main",
        city: "Denver",
        state: "CO",
        zip: 80204,
        email: "alec@gmail.com",
        password: "password"
      )

      visit '/register'
      name = "luke"
      address = "134 Main"
      city = "Denver"
      state = "CO"
      zip = 80214
      email = "alec@gmail.com"
      password = "password"
      password_confirmation = "password"

      fill_in :name, with: name
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip
      fill_in :email, with: email
      fill_in :password, with: password
      fill_in :password_confirmation, with: password_confirmation

      click_button "Submit"

      expect(current_path).to eq("/users")
      expect(page).to have_content("Email has already been taken")
      expect(user_1).to eq(User.last)
      # expect(page).to have_content(name)

      #need to test to see all fields are pre-filled
    end
  end
end
# As a visitor
# When I visit the user registration page
# If I fill out the registration form
# But include an email address already in the system
# Then I am returned to the registration page
# My details are not saved and I am not logged in
# The form is filled in with all previous data except the email field and password fields
# I see a flash message telling me the email address is already in use
