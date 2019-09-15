require 'rails_helper'

describe 'User Registration' do
  describe 'when user clicks on register' do
    it 'they can fill out a form to register new user and are directed to their new profile page with their home address listed' do

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

      fill_in "Name", with: name
      fill_in "Address", with: address
      fill_in "City", with: city
      fill_in "State", with: state
      fill_in "Zip", with: zip
      fill_in "Email", with: email
      fill_in "Password", with: password
      fill_in "Password Confirmation", with: password_confirmation

      click_button "Submit"

      expect(current_path).to eq("/profile")
      expect(page).to have_content("Welcome, #{name}")

      expect(page).to have_content(name)
      expect(page).to have_content(email)
      expect(page).to_not have_content(password)
      expect(page).to have_link('Edit Profile')

      expect(page).to have_content("Address Type: home")
      expect(page).to have_content("Address: #{address}")
      expect(page).to have_content("City: #{city}")
      expect(page).to have_content("State: #{state}")
      expect(page).to have_content("Zip Code: #{zip}")
    end

    xit 'they have to fill out entire form' do

      visit '/register'
      name = "alec"

      fill_in "Name", with: name



      click_button "Submit"

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
        email: "alec@gmail.com",
        password: "password"
      )

      visit '/register'
      name = "luke"
      email = "alec@gmail.com"
      password = "password"
      password_confirmation = "password"

      fill_in "Name", with: name
      fill_in "Email", with: email
      fill_in "Password", with: password
      fill_in "Password Confirmation", with: password_confirmation

      click_button "Submit"
      expect(current_path).to eq("/users")
      expect(page).to have_content("Email has already been taken")
      expect(user_1).to eq(User.last)
      expect(find_field("Name").value).to eq(name)
      expect(find_field("Email").value).to eq(nil)
      expect(find_field("Password").value).to eq(nil)
      expect(find_field("Password Confirmation").value).to eq(nil)
    end
  end
end
