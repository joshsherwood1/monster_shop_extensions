require 'rails_helper'

RSpec.describe "User Profile" do
  describe "As a registered user" do
    before :each do
      @user = User.create(name: 'Christopher', email: 'christopher345354@email.com', password: 'p@ssw0rd', role: 0)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      @user_2 = User.create(name: 'Christopher', email: 'ck@email.com', password: 'p@ssw0rd', role: 0)
      @address_home = @user.addresses.create!(address: "1600 Pennsylvania Ave NW", city: "Washington", state: "DC", zip: 20500)
    end

    it 'I visit my profile page and see all my profile data, including my home address, except my password. I see a link to edit my profile data.' do
      visit '/profile'

      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.email)
      expect(page).to_not have_content(@user.password)
      expect(page).to have_link('Edit Profile')

      within "#address-#{@address_home.id}" do
        expect(page).to have_content("Address Type: #{@address_home.address_type}")
        expect(page).to have_content("Address: #{@address_home.address}")
        expect(page).to have_content("City: #{@address_home.city}")
        expect(page).to have_content("State: #{@address_home.state}")
        expect(page).to have_content("Zip Code: #{@address_home.zip}")
      end
    end

    it 'I click the Edit Profile link. I see a prepopulate form with my current info. I submit the form and am returned to my profile page with my new info.' do
      visit '/profile'
      click_link 'Edit Profile'
      expect(current_path).to eq('/profile/edit')

      expect(find_field(:name).value).to eq(@user.name)
      expect(find_field(:email).value).to eq(@user.email)

      name = 'Christopher H'
      email = 'christopher123456789@email.com'

      fill_in "Name", with: name
      fill_in "Email", with: email
      click_button 'Update Profile'

      expect(current_path).to eq('/profile')

      expect(page).to have_content('Your profile has been updated')
      expect(page).to have_content(name)
      expect(page).to have_content(email)
    end

    it 'I see a link to edit my password. I fill out the form and am returned to my profile. I see a flash message confirming the update.' do
      visit '/profile'
      click_link 'Edit Password'

      expect(current_path).to eq('/profile/password_edit')

      password = 'password'
      password_confirmation = 'password'

      fill_in :password, with: password
      fill_in :password_confirmation, with: password_confirmation

      click_button 'Submit'

      expect(current_path).to eq('/profile')
      expect(page).to have_content('Your password has been updated')
    end

    it 'I have to give the same password in the password and password confirmation fields' do
      visit '/profile'
      click_link 'Edit Password'

      expect(current_path).to eq('/profile/password_edit')

      password = 'password'
      password_confirmation = 'password123456789'

      fill_in :password, with: password
      fill_in :password_confirmation, with: password_confirmation

      click_button 'Submit'

      expect(current_path).to eq('/profile/password_edit')
      expect(page).to have_content("Password confirmation doesn't match Password")
    end

    it 'I must use a unique email address when updating my profile' do
      visit '/profile/edit'

      email = 'ck@email.com'

      fill_in "Email", with: email
      click_button 'Update Profile'

      expect(current_path).to eq('/profile/edit')
      expect(page).to have_content("Email has already been taken")
    end
  end
end
